import 'package:flutter/material.dart';
import 'package:furniture_app/ApiServise/ApiService.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/Screens/ItemDetails.dart';
import 'package:furniture_app/Screens/Items.dart';
import 'package:provider/provider.dart';

class Cartitems extends StatefulWidget {
  const Cartitems({super.key});

  @override
  State<Cartitems> createState() => _CartitemsState();
}

class _CartitemsState extends State<Cartitems> {
  @override
  Widget build(BuildContext context) {
    String _loginmail = Provider.of<Authprovider>(context, listen: false).getMail(); // Moved to build()

    return FutureBuilder<List<dynamic>>(
      future: Apiservice().fetchCartItems(_loginmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Centered the loader
        } 
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } 
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No items in cart'));
        }

        // Cart Items List
        return ListView.builder(
          itemCount: snapshot.data!.length, // FIXED: Added itemCount
          itemBuilder: (context, index) {
            var item = snapshot.data![index];

            return ListTile(
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Itemdetails(item: item)));
                },
                child: Image.network(item['image_url'], width: 60, height: 60, fit: BoxFit.cover)), // Image display
              title: Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Price: Rs. ${item['price']}"),
                  Text("Quantity: ${item['quantity']}"),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Apiservice().deleteCart(item['id'],context);
                  setState(() {}); // Refresh the list
                },
              ),
            );
          },
        );
      },
    );
  }
}

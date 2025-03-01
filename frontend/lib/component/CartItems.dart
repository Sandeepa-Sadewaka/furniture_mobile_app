import 'package:flutter/material.dart';
import 'package:furniture_app/ApiServise/ApiService.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/Screens/ItemDetails.dart';
import 'package:provider/provider.dart';

class Cartitems extends StatefulWidget {
  const Cartitems({super.key});

  @override
  State<Cartitems> createState() => _CartitemsState();
}

class _CartitemsState extends State<Cartitems> {
  @override
  Widget build(BuildContext context) {
    String _loginmail = Provider.of<Authprovider>(context, listen: false).getMail();

    return FutureBuilder<List<dynamic>>(
      future: Apiservice().fetchCartItems(_loginmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No items in cart'));
        }
        print(snapshot.data);

        // Calculate total price
        double sum = 0;
        for (int i = 0; i < snapshot.data!.length; i++) {
          sum += double.parse(snapshot.data![i]['price'].toString()) * 
                 double.parse(snapshot.data![i]['quantity'].toString());
        }

        // Update total in provider
        Provider.of<Authprovider>(context, listen: false).setTotal(sum);

        // Cart Items List
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var item = snapshot.data![index];
            double itemPrice = double.parse(item['price'].toString());
            double totalPrice = itemPrice * double.parse(item['quantity'].toString());

            return ListTile(
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Itemdetails(item: item),
                    ),
                  );
                },
                child: Image.network(
                  item['image_url'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Price: Rs.${totalPrice.toStringAsFixed(2)}"),
                  Text("Quantity: ${item['quantity']}"),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await Apiservice().deleteCart(item['id'], context);
                  setState(() {}); // Refresh UI after deleting
                },
              ),
            );
          },
        );
      },
    );
  }
}

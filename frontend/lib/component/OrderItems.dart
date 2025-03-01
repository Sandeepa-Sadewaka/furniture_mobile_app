import 'package:flutter/material.dart';
import 'package:furniture_app/ApiServise/ApiService.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Orderitems extends StatefulWidget {
  const Orderitems({super.key});

  @override
  State<Orderitems> createState() => _OrderitemsState();
}

class _OrderitemsState extends State<Orderitems> {
  late String user_id;

  @override
  void initState() {
    super.initState();
    user_id = Provider.of<Authprovider>(context, listen: false).getMail();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Apiservice().getOrders(user_id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No orders available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final order = snapshot.data![index];
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: NetworkImage(order['image_url']), height: 150,),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text(order['name'], style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),),
                    Text('Price: Rs. ${order['price']}', style: const TextStyle(fontSize: 18),),
                    Text('Quantity: ${order['quantity']}', style: const TextStyle(fontSize: 18),),
                    Text('Address: ${order['address']}', style: const TextStyle(fontSize: 18),),
                    Text("Phone No: ${order['phoneNo']}", style: const TextStyle(fontSize: 18),),
                    
                    ],
    
                ),
              );
            },
          );
        }
      },
    );
  }
}
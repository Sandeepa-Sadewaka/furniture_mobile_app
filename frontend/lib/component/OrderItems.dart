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
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: Apiservice().getOrders(user_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading orders',
                    style: GoogleFonts.poppins()));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text('No orders yet',
                    style: GoogleFonts.poppins(
                        fontSize: 18, color: Colors.grey[600])),
                SizedBox(height: 8),
                Text('Your orders will appear here',
                    style: GoogleFonts.poppins(color: Colors.grey)),
              ],
            ));
          } else {
            return ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ), // <-- Fixed: closed the shape property here
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order header with status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order #${index + 1}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('Delivered',
                                  style: GoogleFonts.poppins(
                                      color: Colors.green[800],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        Divider(height: 24, thickness: 1),

                        // Product image and details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                order['image_url'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order['name'],
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Shipping details
                        Text('Shipping Details',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        _buildDetailRow(Icons.location_on, order['address']),
                        _buildDetailRow(Icons.phone, order['phoneNo']),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:furniture_app/ApiServise/ApiService.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the Product class

class HomeGridView extends StatefulWidget {
  final String category;
  const HomeGridView({required this.category, super.key});

  @override
  State<HomeGridView> createState() => _HomeGridViewState();
}

class _HomeGridViewState extends State<HomeGridView> {
  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: Apiservice().fetchCategory(widget.category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No items available'));
        } else {
          final products = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
            ),
            itemCount: products.length < 2 ? products.length : 2,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Image.network(product['image_url'], width: 150, height: 150),
                    SizedBox(height: 15),
                    Text(product['name'],
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(height: 5),
                    Text('Rs. ${product['price']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),),
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
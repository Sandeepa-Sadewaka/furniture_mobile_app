// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:furniture_app/ApiServise/ApiService.dart';

class Itemcard extends StatefulWidget {
  const Itemcard({super.key});

  @override
  State<Itemcard> createState() => _ItemcardState();
}

class _ItemcardState extends State<Itemcard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: Apiservice().getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items available'));
          } else {
      
            
            return GridView.builder(
              shrinkWrap: true, // Prevents unnecessary scrolling
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
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
                      Image.network(
                        item["image_url"] ?? "https://via.placeholder.com/150",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 100),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item["name"] ?? "Unknown Item",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Rs. ${item["price"] ?? "N/A"}",
                        style: TextStyle(color: Colors.orange),
                      ),
                      Row(
                        children: [
                          Text("Add to Cart"),
                          Spacer(),
                          IconButton(onPressed: (){},
                           icon: Icon(Icons.add_shopping_cart),
                           color: Colors.orange,)
                        ],
                      ),
                      Container(
                        width: 100,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text("Buy Now",
                          style: TextStyle(color: Colors.white),
                          ),
                        )
                      )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

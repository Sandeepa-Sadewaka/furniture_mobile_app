import 'package:flutter/material.dart';
import 'package:furniture_app/Screens/CartPage.dart';
import 'package:furniture_app/component/ItemCard.dart';
import 'package:google_fonts/google_fonts.dart';

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Text("Items",
        style:GoogleFonts.outfit(fontWeight: FontWeight.bold,),),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (contect)=>Cartpage()));            }, 
            icon: Icon(Icons.shopping_cart)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(child: Itemcard()), // Ensures proper layout
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:furniture_app/component/CartItems.dart';
import 'package:google_fonts/google_fonts.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back, color: Colors.black,)),
        centerTitle: true,
        title: Text("Cart List",
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold,),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Cartitems(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/component/CartItems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  double total = 0.0; // Define the total variable

  @override
  void initState() {
    super.initState();
    total = Provider.of<Authprovider>(context, listen: false).getTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cart List",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
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
              Expanded(child: Cartitems()),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:furniture_app/Screens/BeforeLoginPage.dart';
import 'package:furniture_app/Screens/Cart.dart';
import 'package:furniture_app/Screens/Orders.dart';
import 'package:google_fonts/google_fonts.dart';

class Drawermenu extends StatefulWidget {
  const Drawermenu({super.key});

  @override
  State<Drawermenu> createState() => _DrawermenuState();
}

class _DrawermenuState extends State<Drawermenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: Container(
              height: 150,
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/Images/logo1.png'),
                    height: 100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Home ',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Nest",
                          style: GoogleFonts.outfit(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap:() {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart'),
            onTap:() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Cart()));
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Orders'),
            onTap:() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Orders()));
            },
          ),
          
          SizedBox(height: 250),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap:() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Beforeloginpage()));
            },
          ),
        ],
      ),
    );
  }
}

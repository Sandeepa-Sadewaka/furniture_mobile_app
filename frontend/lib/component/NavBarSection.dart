import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/Screens/Cart.dart';
import 'package:furniture_app/Screens/HomePage.dart';
import 'package:furniture_app/Screens/Orders.dart';

class Navbarsection extends StatefulWidget {
  const Navbarsection({ super.key});

  @override
  State<Navbarsection> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Navbarsection> {
  int _currentIndex = 0;
  late List<Widget> pages =[
    Homepage(),
    Cart(),
    Orders()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 205, 143, 50),
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          Icon(Icons.home, size: 30,),
          Icon(Icons.shopping_cart, size: 30),
          Icon(Icons.download_done_outlined, size: 30),
          ],
      ),
      body: pages[_currentIndex],
    );
    
  }
}
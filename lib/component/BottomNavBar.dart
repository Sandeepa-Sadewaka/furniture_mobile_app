import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/HomePage.dart';
import 'package:furniture_app/Profile.dart';
import 'package:furniture_app/cart.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _currentIndex = 0;
  late List<Widget> pages =[
    Homepage(),
    Cart(),
    Profile(),
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
          Icon(Icons.person, size: 30),
          ],
      ),
      body: pages[_currentIndex],
    );
    
  }
}
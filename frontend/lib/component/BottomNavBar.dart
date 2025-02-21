import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/Screens/Cart.dart';
import 'package:furniture_app/Screens/HomePage.dart';
import 'package:furniture_app/Screens/Profile.dart';
import '../Screens/Cart.dart';
import '../Screens/Profile.dart';

class Bottomnavbar extends StatefulWidget {
  final bool isLogin;
  const Bottomnavbar({required this.isLogin, super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _currentIndex = 0;
  late List<Widget> pages =[
    Homepage(isLogin: widget.isLogin,),
    Cart(),
    Profile()
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
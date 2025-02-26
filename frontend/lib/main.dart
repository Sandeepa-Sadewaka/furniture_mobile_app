import 'package:flutter/material.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/Screens/BeforeLoginPage.dart';
import 'package:furniture_app/Screens/HomePage.dart';
import 'package:furniture_app/Screens/Items.dart';
import 'package:furniture_app/Screens/RegisterPage.dart';
import 'package:furniture_app/component/BottomNavBar.dart';
import 'package:furniture_app/Screens/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>Authprovider()),
    ],
    child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Items(),
    );
  }
}

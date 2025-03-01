import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/Screens/BeforeLoginPage.dart';
import 'package:furniture_app/Screens/CartPage.dart';
import 'package:furniture_app/Screens/HomePage.dart';
import 'package:furniture_app/Screens/Items.dart';
import 'package:furniture_app/Screens/RegisterPage.dart';
import 'package:furniture_app/component/NavBarSection.dart';
import 'package:furniture_app/Screens/login.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51QxPJU4NJSiqp25D4bKrDc6xURByXXh0wboPR0FReF2Cb1OOF6rMhmO8ItSl2ltTIdT9BsZ4WEuPZW4PYgX2338600dMnI27JB";
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
      home: Navbarsection(),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/Screens/login.dart';
import 'package:furniture_app/component/BottomNavBar.dart';
import 'package:furniture_app/utils/constaints.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Apiservice {
  static final Apiservice _instance = Apiservice._internal();

  factory Apiservice() {
    return _instance;
  }

  Apiservice._internal();

  /// Register User
  Future<void> registerUser(
      Map<String, dynamic> users, BuildContext context) async {
    final url = Uri.parse("${baseUrl}registerusers");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(users),
      );

      if (response.statusCode == 200) {
        print("Registraion Success  : ${response.statusCode}");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User Registration Succes")));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else {
        print("Failed to register: ${response.statusCode}");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User Registration Fail")));
      }
    } catch (e) {
      print("Error: $e");
    }

  }







  // fetch users
  Future<void> fetchUser(Map<String, dynamic> user, BuildContext context) async {
    final url = Uri.parse("${baseUrl}login");
    print(user);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data =  jsonDecode(response.body);

        if(data['email'] == user['email'] && data['password'] == user['password']){
          print("User Data Matched");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Loged In")));
          Provider.of<Authprovider>(context, listen: false).login();
          Navigator.push(context, MaterialPageRoute(builder: (context) => Bottomnavbar()));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Credentials")));
        }

      } else {
        print("Failed to load users: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load users")));
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  
    // get all items
    Future <List<dynamic>> getItems()async{
      final url = Uri.parse("${baseUrl}products");
      try {
        final response = await http.get(
          url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          );
        if(response.statusCode == 200){
          List<dynamic> data = jsonDecode(response.body);
          return data;
        }else{
          print("Failed to load items: ${response.statusCode}");
          return [];
        }
      } catch (e) {
        print("Error: $e");
        return [];
      }

    }
}

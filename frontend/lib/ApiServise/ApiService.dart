import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:furniture_app/Screens/login.dart';
import 'package:furniture_app/utils/constaints.dart';
import 'package:http/http.dart' as http;

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
        print(data['email']);
        print("/n");
        print(user['email']);
        print(data['email'] == user['email']);

        String password = data['password'];
        print(password);
        print("/n");
        print(user['password']);
        print(password == user['password']);
        
        if(data['email'] == user['email'] && data['password'] == user['password']){
          print("User Data Matched");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Loged In")));
          /*Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));*/
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
}

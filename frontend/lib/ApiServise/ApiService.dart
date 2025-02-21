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
  Future<bool?> registerUser(
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
        return true;
      } else {
        print("Failed to register: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // fetch users
  Future<List<dynamic>> fetchUser() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Failed to load users: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}

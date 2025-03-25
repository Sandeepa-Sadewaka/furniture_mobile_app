import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/Screens/login.dart';
import 'package:furniture_app/component/NavBarSection.dart';
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
        return ;
      }
  }

  // fetch users
  Future<void> fetchUser(
      Map<String, dynamic> user, BuildContext context) async {
    final url = Uri.parse("${baseUrl}login");
    print(user);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data['email'] == user['email'] &&
            data['password'] == user['password']) {
          print("User Data Matched");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Loged In")));

          Provider.of<Authprovider>(context, listen: false).login();
          Provider.of<Authprovider>(context, listen: false)
              .setMail(data['email']);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Navbarsection()));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
        }
      } else {
        print("Failed to load users: ${response.statusCode}");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to load users")));
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // get all items
  Future<List<dynamic>> getItems() async {
    final url = Uri.parse("${baseUrl}products");
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print("Failed to load items: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  // add to cart
  Future<void> addToCart(
      Map<String, dynamic> cart, BuildContext context) async {
    final url = Uri.parse("${baseUrl}addtocart");
    print(cart['userID']);
    print(cart['productId']);
    print(cart['quantity']);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(cart),
      );
      if (response.statusCode == 200) {
        print("Item Added to Cart");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Item Added to Cart")));
      } else {
        print("Failed to add item to cart: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add item to cart")));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<List<dynamic>> fetchCartItems(String user_id) async {
    final url = Uri.parse("${baseUrl}cart?user_id=$user_id");

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print(
            "Failed to load cart items: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching cart: $e");
      return [];
    }
  }

  // delete cart
  Future<void> deleteCart(int cart_id, BuildContext context) async {
    final url =
        Uri.parse("${baseUrl}deletecart?cart_id=$cart_id"); // Use Query Param

    print("Deleting Cart Item ID: $cart_id");
    try {
      final response = await http.delete(
        // Use DELETE instead of POST
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        print("Item Deleted from Cart");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Item Deleted from Cart")));
      } else {
        print("Failed to delete item from cart: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to delete item from cart")));
      }
    } catch (e) {
      print("Error: $e");
    }
  }

// Checkout Single Item
  Future<void> checkoutSingleItem({
    required String userID,
    required String productID,
    required int quantity,
    required double price,
  }) async {
    try {
      //  Create Payment Method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: const PaymentMethodData(),
        ),
      );

      //  Send Payment & Order Request to Backend
      final url = Uri.parse("${baseUrl}checkout");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": userID,
          "product_id": productID,
          "quantity": quantity,
          "price": price,
          "payment_method_id": paymentMethod.id,
        }),
      );

      // Handle API Response
      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          print(" Order Successful: ${responseData['order_id']}");
          // Show success message to user
        } catch (e) {
          print(" Failed to parse response: $e");
        }
      } else {
        print(" Order Failed: ${response.statusCode}");
        print(" Error Message: ${response.body}");
      }
    } catch (e) {
      print(" Payment Error: $e");
    }
  }

  // Order payment
  Future<void> checkoutOrder(
      Map<String, dynamic> order, BuildContext context) async {
    final url = Uri.parse("${baseUrl}checkout");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(order),
      );

      if (response.statusCode == 200) {
        print("Order Success  : ${response.statusCode}");
      } else {
        print("Failed to order: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // fetch one category
  Future<List<dynamic>> fetchCategory(String category) async {
    final url = Uri.parse("${baseUrl}category?category=$category");
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print("Failed to load items: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }


  //get orders
  Future<List<dynamic>> getOrders(String user_id) async {
    final url = Uri.parse("${baseUrl}orders?user_id=$user_id");
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print("Failed to load items: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }


  //search products
  Future<List<dynamic>> searchProducts(String nameItem) async {
    final url = Uri.parse("${baseUrl}search?nameItem=$nameItem");
    print(nameItem);
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print("Failed to load items: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  //get offer item
  Future<List<dynamic>> getOfferItem() async {
    final url = Uri.parse("${baseUrl}offers");
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print("Failed to load items: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

}

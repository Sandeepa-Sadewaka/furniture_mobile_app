import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePaymentService {
  // 🚨 Do NOT hardcode this in frontend. Move to backend!
  static const String _stripeSecretKey = "sk_test_51QxPJU4NJSiqp25D99h20dl7glx2rhcvB68xC7irz9s4zNmk6zou2fqoopxyJcWOYK0s1ETKJ6pPHDqj1TJUJz5w00uHWMHYQE";
  
  /// 🔹 Create Payment Intent (Backend should handle this!)
  static Future<Map<String, dynamic>?> createPaymentIntent(double amount) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: {
          'amount': (amount * 100).toInt().toString(), 
          'currency': 'LKR',
          'payment_method_types[]': 'card',
        },
        headers: {
          'Authorization': 'Bearer $_stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  /// 🔹 Confirm and Present Payment Sheet
  static Future<bool> confirmPaymentIntent(double amount) async {
    try {
      final paymentIntent = await createPaymentIntent(amount);
      if (paymentIntent == null) {
        print("Payment Intent creation failed!");
        return false;
      }

      // ✅ Initialize Stripe payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: "Furniture App",
          style: ThemeMode.light,
        ),
      );

      // ✅ Show payment sheet
      await Stripe.instance.presentPaymentSheet();

      print("✅ Payment Successful!");
      return true;
    } catch (e) {
      if (e is StripeException) {
        print("🛑 Payment Canceled: ${e.error.localizedMessage}");
      } else {
        print("🛑 Unexpected Error: $e");
      }
      return false;
    }
  }
}

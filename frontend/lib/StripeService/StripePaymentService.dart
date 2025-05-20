import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furniture_app/utils/constaints.dart';
import 'package:http/http.dart' as http;

class StripePaymentService {
  static bool _isInitialized = false;
  static const String _publishableKey =
      'pk_test_51QxPJU4NJSiqp25D4bKrDc6xURByXXh0wboPR0FReF2Cb1OOF6rMhmO8ItSl2ltTIdT9BsZ4WEuPZW4PYgX2338600dMnI27JB';

  /// Initialize Stripe with publishable key
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      Stripe.publishableKey = _publishableKey;
      await Stripe.instance.applySettings();
      _isInitialized = true;
      debugPrint('Stripe initialized successfully');
    } catch (e) {
      _isInitialized = false;
      debugPrint('Stripe initialization failed: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> _createPaymentIntent(
    double amount, {
    String currency = 'lkr',
  }) async {
    try {
      // Convert amount to cents/pence (smallest currency unit)
      final amountInCents = (amount * 100).toInt();
      debugPrint('Creating payment intent for amount: $amountInCents $currency');

      final uri = Uri.parse('${baseUrl}stripe/create-payment-intent');
      debugPrint('Making request to: $uri');

      final body = jsonEncode({
        'amount': amountInCents,
        'currency': currency.toLowerCase(),
      });
      debugPrint('Request body: $body');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      ).timeout(const Duration(seconds: 30));

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['clientSecret'] == null) {
          throw Exception(
              'Invalid payment intent response. Missing clientSecret');
        }
        return data;
      } else {
        throw Exception(
            'Server error: ${response.statusCode}. Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Payment intent creation error: $e');
      rethrow;
    }
  }

  static Future<PaymentResult> confirmPayment(
      double amount, BuildContext context) async {
    try {
      debugPrint('Starting payment process...');

      if (!_isInitialized) {
        debugPrint('Initializing Stripe...');
        await initialize();
      }

      debugPrint('Creating payment intent...');
      final paymentIntent = await _createPaymentIntent(amount);
      debugPrint('Payment intent created: ${paymentIntent['id']}');

      debugPrint('Initializing payment sheet...');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['clientSecret'],
          merchantDisplayName: 'Furniture App',
          style: ThemeMode.light,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Theme.of(context).primaryColor,
              background: Theme.of(context).scaffoldBackgroundColor,
              componentBorder: Colors.grey.shade200,
            ),
          ),
        ),
      );

      debugPrint('Presenting payment sheet...');
      await Stripe.instance.presentPaymentSheet();
      debugPrint('Payment completed successfully!');

      return PaymentResult.success();
    } on StripeException catch (e) {
      debugPrint('STRIPE EXCEPTION: ${e.error.localizedMessage}');
      debugPrint('Error code: ${e.error.code}');
      debugPrint('Decline code: ${e.error.declineCode}');
      debugPrint('Stripe message: ${e.error.message}');

      String userMessage = e.error.localizedMessage ?? 'Payment failed';
      
      // Handle specific Stripe error cases
      if (e.error.code == FailureCode.Canceled) {
        userMessage = 'Payment was canceled';
      } else if (e.error.code == FailureCode.Failed) {
        userMessage = 'Payment failed. Please check your payment details.';
      } else if (e.error.code == FailureCode.Timeout) {
        userMessage = 'Payment timed out. Please try again.';
      }

      return PaymentResult.failure(
        errorType: PaymentErrorType.stripeError,
        message: userMessage,
        details: 'Code: ${e.error.code}',
      );
    } catch (e, stack) {
      debugPrint('UNEXPECTED ERROR: $e');
      debugPrint('STACK TRACE: $stack');

      return PaymentResult.failure(
        errorType: PaymentErrorType.unknown,
        message: 'Payment processing failed',
        details: 'Error: ${e.toString()}',
      );
    }
  }
}

class PaymentResult {
  final bool isSuccess;
  final PaymentErrorType? errorType;
  final String message;
  final String? details;

  PaymentResult.success()
      : isSuccess = true,
        errorType = null,
        message = 'Payment successful',
        details = null;

  PaymentResult.failure({
    required this.errorType,
    required this.message,
    this.details,
  }) : isSuccess = false;

  @override
  String toString() => isSuccess
      ? 'Payment successful'
      : 'Payment failed: ${errorType?.name} - $message${details != null ? '\n$details' : ''}';
}

enum PaymentErrorType {
  stripeError,
  networkError,
  timeout,
  validationError,
  unknown,
}
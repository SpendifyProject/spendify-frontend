import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:spendify/const/constants.dart';
import 'package:spendify/const/snackbar.dart';

import '../models/paystack_response.dart';
import '../models/transaction.dart';

class PaystackService {
  final String _secretKey = dotenv.env['PAYSTACK_SECRET_KEY'] ?? 'NO_KEY_FOUND';
  final String _baseUrl = 'https://api.paystack.co';

  Future<PayStackResponse> createTransaction(Transaction transaction) async {
    String url = "$_baseUrl/transaction/initialize";
    String email = firebaseEmail;
    final data = transaction.toPaystackJson(email);
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data),
      );
      if (res.statusCode == 200) {
        final resData = jsonDecode(res.body);
        return PayStackResponse.fromJson(resData['data']);
      }
      throw "Payment unsuccessful. Status code: ${res.statusCode}, ${res.body}";
    } on Exception {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<Object?> initTransaction(
      Transaction transaction, BuildContext context) async {
    try {
      final authRes = await createTransaction(transaction);
      return authRes.authorizationUrl;
    } catch (e) {
      log('Error: $e');
      if (context.mounted) {
        showCustomSnackbar(
          context,
          "It appears you previously used this reference. Reference Field cannot be a duplicate. Enter a new unique Reference",
        );
      }
      return null;
    }
  }

  Future<bool> verifyTransaction(
      Transaction transaction, BuildContext context) async {
    try {
      String reference =
          '${completeTrim(transaction.reference)}${transaction.date.millisecondsSinceEpoch}';
      String url = "https://api.paystack.co/transaction/verify/$reference";
      final res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_secretKey',
        },
      );
      final resData = jsonDecode(res.body);
      if (resData['status'] == true &&
          resData['data'] is Map<String, dynamic>) {
        if (resData['data']['status'] == "success") {
          return true;
        }
      }
      showCustomSnackbar(
          context, "Complete Transaction before tapping this button");
      return false;
    } catch (e) {
      showCustomSnackbar(context, "Error verifying Transaction: $e");
      return false;
    }
  }
}

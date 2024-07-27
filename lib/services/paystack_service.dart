import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/widgets/error_dialog.dart';

import '../models/paystack_response.dart';
import '../models/transaction.dart';

class PaystackService {
  final String _secretKey = dotenv.env['PAYSTACK_SECRET_KEY'] ?? 'NO_KEY_FOUND';
  final String _baseUrl = 'https://api.paystack.co';

  Future<PayStackResponse> createTransaction(Transaction transaction) async {
    String url = "$_baseUrl/transaction/initialize";
    String email = FirebaseAuth.instance.currentUser!.email.toString();
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
      print(transaction.reference);
      print(res.body);
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
      if(context.mounted){
        showCustomSnackbar(context, "It appears you previously used this reference. Reference Field cannot be a duplicate. Enter a new unique Reference",);
      }
      //rethrow;
      return null;
    }
  }

  Future<dynamic> verifyTransaction(Transaction transaction, BuildContext context) async {
    try {
      String reference ='${transaction.reference}${transaction.date.microsecondsSinceEpoch}';
      print(reference);
      String url =
          "https://api.paystack.co/transaction/verify/$reference";
      final res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_secretKey',
        },
      );
      final resData = jsonDecode(res.body);
      print(resData);
      if (resData['data']["status"] == "success") {
        return true;
      }
      return showErrorDialog(context, "Complete Transaction before tapping this button");
      // return (resData["status"]);
    } catch (e) {
      showErrorDialog(context, "Error verifying Transaction: $e");
    }
  }
}

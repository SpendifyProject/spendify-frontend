import 'package:flutter/material.dart';
import 'package:spendify/const/paystack_transaction.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/transaction.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView(
      {super.key, required this.transaction});

  final Transaction transaction;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late Future futureInitTransaction;

  @override
  void initState() {
    super.initState();
    futureInitTransaction = PaystackService().initTransaction(
      widget.transaction,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: color.onPrimary,
            size: 20,
          ),
        ),
        title: Text(
          'Complete Payment',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18,
          ),
        ),
      ),
      body: FutureBuilder(
        future: futureInitTransaction,
        builder: (context, snapshot) {
          final url = snapshot.data ?? 'https://flutter.dev';
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorDialog(context, 'Error: ${snapshot.error}');
            });
          } else if (snapshot.hasData) {
            return WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(Colors.white)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {},
                    onHttpError: (HttpResponseError error) {},
                    onWebResourceError: (WebResourceError error) {},
                    onNavigationRequest: (NavigationRequest request) {
                      if (request.url.startsWith('https://www.youtube.com/')) {
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(Uri.parse(url)),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

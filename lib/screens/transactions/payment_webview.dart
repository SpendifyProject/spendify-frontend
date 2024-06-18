import 'package:flutter/material.dart';
import 'package:spendify/const/paystack_transaction.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/transaction.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({super.key, required this.transaction});

  final Transaction transaction;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late Future futureInitTransaction;
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    futureInitTransaction =
        PaystackService().initTransaction(widget.transaction, context);
  }

  @override
  void dispose() {
    webViewController.clearCache();
    super.dispose();
  }

  void verifyTransactionAfterCompletion() async {
    bool success =
        await PaystackService().verifyTransaction(widget.transaction, context);
    if (success) {
      Navigator.pop(context, true);
    } else {
      showErrorDialog(context, 'Transaction verification failed.');
    }
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
          print(url);
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const SizedBox();
          // } else if (snapshot.hasError) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     showErrorDialog(context, 'Error: ${snapshot.error}');
          //   });
          // }
          if (snapshot.hasData) {
            return WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(const Color(0x00000000))
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      print('Progress...');
                    },
                    onPageStarted: (String url) {
                      print('Page Started...');
                    },
                    onPageFinished: (String url) {
                      print('Page Finished...');
                      if (url.contains('transaction-complete')) {
                        verifyTransactionAfterCompletion();
                      }
                    },
                    onWebResourceError: (WebResourceError error) {
                      print('Page resource error: ${error.description}');
                      showErrorDialog(
                          context, 'Error loading page: ${error.description}');
                    },
                    onNavigationRequest: (NavigationRequest request) {
                      print('Nav request...${request.url}');
                      if (request.url.startsWith('https://www.youtube.com/')) {
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(
                  Uri.parse(url!),
                ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

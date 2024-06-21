import 'package:flutter/material.dart';
import 'package:spendify/services/paystack_service.dart';
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
  late final PlatformWebViewControllerCreationParams params;

  @override
  void initState() {
    super.initState();
    futureInitTransaction =
        PaystackService().initTransaction(widget.transaction, context);
    params = const PlatformWebViewControllerCreationParams();
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
      resizeToAvoidBottomInset: false,
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
      body: SafeArea(
        child: FutureBuilder(
          future: futureInitTransaction,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final url = snapshot.data ?? 'https://flutter.dev';
              print(url);
              return WebViewWidget(
                controller: WebViewController.fromPlatformCreationParams(params)
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(const Color(0x00000000))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onProgress: (int progress) {
                        // Update loading bar.
                      },
                      onPageStarted: (String url) {},
                      onPageFinished: (String url) {},
                      onWebResourceError: (WebResourceError error) {},
                      onNavigationRequest: (NavigationRequest request) {
                        print('Navigation request');
                        print(url);
                        print(request.url);
                        print(request);
                        if (request.url
                            .startsWith('https://www.youtube.com/')) {
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
      ),
    );
  }
}

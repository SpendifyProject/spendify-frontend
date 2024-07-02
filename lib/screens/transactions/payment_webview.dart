import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendify/screens/animations/done.dart';
import 'package:spendify/screens/dashboard/dashboard.dart';
import 'package:spendify/services/paystack_service.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return DoneScreen(
              nextPage: Dashboard(
                email: FirebaseAuth.instance.currentUser!.email.toString(),
              ),
            );
          },
        ),
      );
    } else {
      showErrorDialog(_scaffoldKey.currentContext!, 'Transaction verification failed.');
    }
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    print("Attempting to launch URL: $url");
    bool canLaunch = await canLaunchUrl(uri);
    print("Can launch URL: $canLaunch");
    if (canLaunch) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
      print("URL launched successfully");
    } else {
      showErrorDialog(_scaffoldKey.currentContext!, 'Could not launch $url');
      print("Could not launch URL");
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
              _launchURL(url);
              verifyTransactionAfterCompletion();

              // return WebViewWidget(
              //   controller: WebViewController.fromPlatformCreationParams(params)
              //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
              //     ..setBackgroundColor(const Color(0x00000000))
              //     ..setNavigationDelegate(
              //       NavigationDelegate(
              //         onProgress: (int progress) {
              //           // Update loading bar.
              //         },
              //         onPageStarted: (String url) {},
              //         onPageFinished: (String url) {},
              //         onWebResourceError: (WebResourceError error) {},
              //         onNavigationRequest: (NavigationRequest request) {
              //           print('Navigation request');
              //           print(url);
              //           print(request.url);
              //           print(request);
              //           if (request.url
              //               .startsWith('https://www.youtube.com/')) {
              //             return NavigationDecision.prevent;
              //           }
              //           return NavigationDecision.navigate;
              //         },
              //       ),
              //     )
              //     ..loadRequest(
              //       Uri.parse(url!),
              //     ),
              // );
            }
            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: GestureDetector(
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: color.primary,
          ),
        ),
      ),
    );
  }
}

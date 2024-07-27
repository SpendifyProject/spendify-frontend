import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/constants.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/provider/transaction_provider.dart';
import 'package:spendify/screens/animations/done.dart';
import 'package:spendify/screens/dashboard/dashboard.dart';
import 'package:spendify/services/notification_service.dart';
import 'package:spendify/services/paystack_service.dart';
import 'package:uuid/uuid.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:spendify/models/notification.dart' as n;

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
  late TransactionProvider transactionProvider;
  late final PlatformWebViewControllerCreationParams params;
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    futureInitTransaction =
        PaystackService().initTransaction(widget.transaction, context);
    params = const PlatformWebViewControllerCreationParams();
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
  }

  @override
  void dispose() {
    webViewController.clearCache();
    super.dispose();
  }

  // void verifyTransactionAfterCompletion() async {
  //   bool success =
  //       await PaystackService().verifyTransaction(widget.transaction, context);
  //   if (success) {
  //     transactionProvider.saveTransaction(widget.transaction);
  //     n.Notification notification = n.Notification(
  //       title: 'Transaction completed',
  //       body:
  //           'Your payment of GHc ${formatAmount(widget.transaction.amount)} to ${widget.transaction.recipient} has been competed.',
  //       date: widget.transaction.date,
  //     );
  //     await NotificationService.showInstantNotification(notification);
  //     showCustomSnackbar(
  //       context,
  //       'Transaction completed successfully',
  //     );
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return DoneScreen(
  //             nextPage: Dashboard(
  //               email: FirebaseAuth.instance.currentUser!.email.toString(),
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   } else {
  //     showErrorDialog(
  //         _scaffoldKey.currentContext!, 'Transaction verification failed.');
  //     Navigator.pop(_scaffoldKey.currentContext!);
  //   }
  // }

  // Future<void> _launchURL(String url) async {
  //   Uri uri = Uri.parse(url);
  //   // print("Attempting to launch URL: $url");
  //   bool canLaunch = await canLaunchUrl(uri);
  //   // print("Can launch URL: $canLaunch");
  //   if (canLaunch) {
  //     await launchUrl(uri, mode: LaunchMode.inAppWebView);
  //     // print("URL launched successfully");
  //   } else {
  //     showErrorDialog(_scaffoldKey.currentContext!, 'Could not launch $url');
  //     // print("Could not launch URL");
  //   }
  // }

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
            size: 20.sp,
          ),
        ),
        title: Text(
          'Complete Payment',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureInitTransaction,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final url = snapshot.data ?? 'https://flutter.dev';
              // _launchURL(url);
              return WebViewWidget(
                controller: WebViewController.fromPlatformCreationParams(params)
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(color.surface)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onProgress: (int progress) {},
                      onPageStarted: (String url) {},
                      onPageFinished: (String url) {},
                      onWebResourceError: (WebResourceError error) {},
                      onNavigationRequest: (NavigationRequest request) {
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
              // verifyTransactionAfterCompletion();
            }
            return const SizedBox();
          },
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () async {
          if (await PaystackService()
              .verifyTransaction(widget.transaction, context)) {
            transactionProvider.saveTransaction(widget.transaction);
            n.Notification notification = n.Notification(
              title: 'Transaction completed',
              body:
                  'Your payment of GHc ${formatAmount(widget.transaction.amount)} to ${widget.transaction.recipient} has been competed.',
              date: widget.transaction.date,
              uid: widget.transaction.uid,
              id: const Uuid().v4(),
            );
            await NotificationService.showInstantNotification(notification);
            showCustomSnackbar(
              context,
              'Transaction completed successfully',
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoneScreen(
                    nextPage: Dashboard(
                      email: firebaseEmail,
                    ),
                  );
                },
              ),
            );
          } else {
            showCustomSnackbar(context, 'Transaction could not be verified');
            Navigator.pop(context);
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 100.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color.primary,
          ),
          child: Text(
            'Transaction Completed',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

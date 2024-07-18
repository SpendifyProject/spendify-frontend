import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

List<String> categories = [
  'Entertainment',
  'Food and Dining',
  'Rent and Housing',
  'Health and Fitness',
  'Shopping',
  'Transport',
  'Utilities and Repairs',
  'Other'
];

final List<Color> categoryColors = [
  Colors.redAccent,
  Colors.greenAccent,
  Colors.lightBlueAccent,
  Colors.orangeAccent,
  Colors.purpleAccent,
  Colors.yellow,
  Colors.cyanAccent,
  Colors.grey,
];

IconData pickCategoryIcon(String category) {
  if (category == 'Entertainment') {
    return Icons.movie_filter_outlined;
  } else if (category == 'Food and Dining') {
    return Icons.fastfood_outlined;
  } else if (category == 'Rent and Housing') {
    return Icons.house_outlined;
  } else if (category == 'Health and Fitness') {
    return Icons.health_and_safety_outlined;
  } else if (category == 'Shopping') {
    return Icons.shopping_bag_outlined;
  } else if (category == 'Transport') {
    return Icons.directions_bus_filled_outlined;
  } else if (category == 'Utilities and Repairs') {
    return Icons.electrical_services_sharp;
  } else {
    return Icons.more_horiz;
  }
}

String formatAmount(double amount) {
  final formatter = NumberFormat("#,##0.00", "en_UK");
  return formatter.format(amount);
}

double amountToPercentages(double amount, double totalExpenses) {
  return ((amount / totalExpenses) * 100).roundToDouble();
}

String getTimeLeft(DateTime deadline) {
  final DateTime now = DateTime.now();
  final Duration difference = deadline.difference(now);

  if (difference.inDays >= 365) {
    final int years = (difference.inDays / 365).round();
    return years == 1 ? '1 year left' : '$years years left';
  } else if (difference.inDays >= 30) {
    final int months = (difference.inDays / 30).round();
    return months == 1 ? '1 month left' : '$months months left';
  } else if (difference.inDays > 0) {
    return difference.inDays == 1
        ? '1 day left'
        : '${difference.inDays} days left';
  } else {
    return '0 days left';
  }
}

void popAndPushReplacement(BuildContext context, Widget newPage) {
  Navigator.pop(context);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => newPage),
  );
}

String firebaseEmail = FirebaseAuth.instance.currentUser!.email.toString();

Future<void> sendEmail({
  required String toEmail,
  required String subject,
  required String body,
}) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: toEmail,
    query: _encodeQueryParameters(<String, String>{
      'subject': subject,
      'body': body,
    }),
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'Could not launch $emailUri';
  }
}

String? _encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

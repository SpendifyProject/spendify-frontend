import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCardWidget extends StatelessWidget {
  const CreditCardWidget(
      {super.key,
      required this.cardNumber,
      required this.fullName,
      required this.expiryDate,
      required this.assetName});

  final String cardNumber;
  final String fullName;
  final String expiryDate;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: 335.w,
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color.fromRGBO(30, 30, 45, 1),
        image: const DecorationImage(
          image: AssetImage('assets/images/worldmap.png'),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 20.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardNumber.replaceAllMapped(
                RegExp(r".{4}"),
                (match) => "${match.group(0)}   ",
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            Text(
              fullName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Expiry Date',
                style: TextStyle(
                  color: color.secondary,
                  fontSize: 9,
                ),
              ),
              subtitle: Text(
                expiryDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              trailing: Image.asset('assets/images/$assetName'),
            ),
          ],
        ),
      ),
    );
  }
}

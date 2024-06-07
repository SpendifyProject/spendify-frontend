import 'package:flutter/material.dart';

import '../const/sizing_config.dart';

class MomoWidget extends StatelessWidget {
  const MomoWidget(
      {super.key,
      required this.phoneNumber,
      required this.fullName,
      required this.network});

  final String phoneNumber;
  final String fullName;
  final String network;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: horizontalConverter(context, 335),
      height: verticalConverter(context, 180),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.onPrimary,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          verticalConverter(context, 20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              phoneNumber,
              style: TextStyle(
                color: color.background,
                fontSize: verticalConverter(context, 24),
              ),
            ),
            Text(
              fullName,
              style: TextStyle(
                color: color.background,
                fontSize: verticalConverter(context, 14),
              ),
            ),
            const Spacer(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Network',
                style: TextStyle(
                  color: color.secondary,
                  fontSize: verticalConverter(context, 9),
                ),
              ),
              subtitle: Text(
                network.toUpperCase(),
                style: TextStyle(
                  color: color.background,
                  fontSize: verticalConverter(context, 13),
                ),
              ),
              trailing: Image.asset(
                'assets/images/${network.toLowerCase()}.jpg',
                height: verticalConverter(context, 30),
                width: horizontalConverter(context, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

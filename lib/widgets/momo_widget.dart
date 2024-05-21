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
      height: verticalConverter(context, 240),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.onPrimary,
        image: const DecorationImage(
          image: AssetImage('assets/images/worldmap.png'),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(verticalConverter(context, 20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: verticalConverter(context, 30),
            ),
            Text(
              phoneNumber,
              style: TextStyle(
                color: color.background,
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 10),
            ),
            Text(
              fullName,
              style: TextStyle(
                color: color.background,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Network',
                style: TextStyle(
                  color: color.secondary,
                  fontSize: 9,
                ),
              ),
              subtitle: Text(
                network,
                style: TextStyle(
                  color: color.background,
                  fontSize: 13,
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

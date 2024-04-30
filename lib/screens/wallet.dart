import 'package:flutter/material.dart';
import 'package:spendify/const/sizing_config.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: null,
          icon: Icon(
            Icons.arrow_back_ios,
            color: color.onPrimary,
            size: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.add,
              color: color.onPrimary,
              size: 20,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalConverter(context, 10),
          horizontal: horizontalConverter(context, 20),
        ),
        child: ListView(
          children: [
            Text(
              'Monthly spending limit',
              style: TextStyle(
                fontSize: 18,
                color: color.onPrimary,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 10),
            ),
            Center(
              child: Container(
                width: horizontalConverter(context, 335),
                height: verticalConverter(context, 113),
                padding: EdgeInsets.all(
                  verticalConverter(context, 20),
                ),
                decoration: BoxDecoration(
                  color: color.onBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount: GHc8,545.00',
                      style: TextStyle(
                        fontSize: 13,
                        color: color.onPrimary,
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: Colors.white,
                          thumbColor: Colors.blue,
                        ),
                        child: const Slider(
                          value: 4600.0,
                          min: 0.0,
                          max: 10000.0,
                          divisions: 50,
                          onChanged: null,
                          label: 'GHc 4600.00',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

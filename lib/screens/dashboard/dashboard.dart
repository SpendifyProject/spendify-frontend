import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendify/screens/dashboard/home.dart';
import 'package:spendify/screens/dashboard/stats.dart';
import 'package:spendify/screens/dashboard/wallet.dart';
import 'package:spendify/screens/dashboard/settings/settings.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.email});

  final String email;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final List<Widget> screens = [
      Home(email: widget.email,),
      const Wallet(),
      const Statistics(),
      const SettingsScreen(),
    ];
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 5,
        selectedItemColor: color.primary,
        unselectedItemColor: color.onSecondary,
        backgroundColor: color.onBackground,
        showUnselectedLabels: true,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.wallet_outlined),
              label: 'Wallet'
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar),
              label: 'Statistics'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings'
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendify/screens/home.dart';
import 'package:spendify/screens/stats.dart';
import 'package:spendify/screens/wallet.dart';
import 'package:spendify/screens/settings.dart';

final List<Widget> _screens = [
  const Home(),
  const Wallet(),
  const Statistics(),
  const SettingsScreen(),
];

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 5,
        selectedItemColor: color.primary,
        unselectedItemColor: color.onSecondary,
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:spendify/screens/dashboard/home.dart';
import 'package:spendify/screens/dashboard/stats.dart';
import 'package:spendify/screens/dashboard/budget.dart';
import 'package:spendify/screens/dashboard/settings/settings.dart';
import 'package:spendify/widgets/error_dialog.dart';

import '../../models/user.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.email});

  final String email;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: FutureBuilder(
        future: userProvider.getUserData(widget.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            showErrorDialog(context, '${snapshot.error}');
          }
          User user = userProvider.user;
          final List<Widget> screens = [
            Home(
            user: user,
            ),
            Wallet(
              user: user,
            ),
            Statistics(
              user: user,
            ),
            const SettingsScreen(),
          ];
          return screens[currentIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 0,
        selectedItemColor: color.primary,
        unselectedItemColor: color.onSecondary,
        backgroundColor: color.surface,
        showUnselectedLabels: true,
        useLegacyColorScheme: false,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.savings_outlined), label: 'Budget'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar), label: 'Statistics'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

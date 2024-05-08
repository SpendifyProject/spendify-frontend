import 'package:flutter/material.dart';
import 'package:spendify/const/routes.dart';
import 'package:spendify/const/sizing_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkModeEnabled = false;
  bool isBiometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.logout,
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
              'General',
              style: TextStyle(
                fontSize: 14,
                color: color.secondary,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 10),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  isDarkModeEnabled = !isDarkModeEnabled;
                });
              },
              inactiveThumbColor: color.secondary,
              inactiveTrackColor: color.onBackground,
              activeColor: color.primary,
              title: Text(
                'Enable Dark Mode',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14,
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.of(context).pushNamed(profileRoute);
              },
              title: Text(
                'My Profile',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color.secondary,
                size: 20,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: (){
                Navigator.pushNamed(context, contactRoute);
              },
              title: Text(
                'Contact Us',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color.secondary,
                size: 20,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 25),
            ),
            Text(
              'Security',
              style: TextStyle(
                fontSize: 14,
                color: color.secondary,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 10),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: (){
                Navigator.pushNamed(context, changePasswordRoute);
              },
              title: Text(
                'Change Password',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color.secondary,
                size: 20,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: (){
                Navigator.pushNamed(context, conditionsRoute);
              },
              title: Text(
                'Terms and Conditions',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color.secondary,
                size: 20,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: (){
                Navigator.pushNamed(context, privacyRoute);
              },
              title: Text(
                'Privacy Policy',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color.secondary,
                size: 20,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 25),
            ),
            Text(
              'Change what data you share with us',
              style: TextStyle(
                fontSize: 14,
                color: color.secondary,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 10),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: isBiometricEnabled,
              onChanged: (value) {
                setState(() {
                  isBiometricEnabled = !isBiometricEnabled;
                });
              },
              inactiveThumbColor: color.secondary,
              inactiveTrackColor: color.onBackground,
              activeColor: color.primary,
              title: Text(
                'Biometrics',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

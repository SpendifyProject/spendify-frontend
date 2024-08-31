import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/routes.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/provider/biometric_provider.dart';
import 'package:spendify/provider/theme_provider.dart';
import 'package:spendify/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeProvider themeProvider;
  late BiometricProvider biometricProvider;

  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    biometricProvider = Provider.of<BiometricProvider>(context, listen: false);
    log(biometricProvider.biometricEnabled.toString());
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOut(context);
            },
            icon: Icon(
              Icons.logout,
              color: color.onPrimary,
              size: 20.sp,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 20.w,
        ),
        child: ListView(
          children: [
            Text(
              'General',
              style: TextStyle(
                fontSize: 14.sp,
                color: color.secondary,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: themeProvider.isDarkThemeEnabled,
              onChanged: (value) {
                setState(() {
                  themeProvider.switchTheme();
                });
              },
              inactiveThumbColor: color.onPrimary,
              inactiveTrackColor: color.onSurface,
              activeColor: color.primary,
              title: Text(
                'Enable Dark Mode',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14.sp,
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
                  fontSize: 14.sp,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color.secondary,
                size: 20.sp,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.pushNamed(context, contactRoute);
              },
              title: Text(
                'Contact Us',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14.sp,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color.secondary,
                size: 20.sp,
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Text(
              'Security',
              style: TextStyle(
                fontSize: 14.sp,
                color: color.secondary,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.pushNamed(context, changePasswordRoute);
              },
              title: Text(
                'Change Password',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14.sp,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color.secondary,
                size: 20.sp,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.pushNamed(context, conditionsRoute);
              },
              title: Text(
                'Terms and Conditions',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14.sp,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color.secondary,
                size: 20.sp,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.pushNamed(context, privacyRoute);
              },
              title: Text(
                'Privacy Policy',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14.sp,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: color.secondary,
                size: 20.sp,
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Text(
              'Change what data you share with us',
              style: TextStyle(
                fontSize: 14.sp,
                color: color.secondary,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            FutureBuilder(
              future: biometricProvider.loadBiometrics(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const SizedBox();
                }
                else if(snapshot.hasData){
                  return SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: biometricProvider.isBiometricEnabled,
                    onChanged: (value) async{
                      bool isSupported = await LocalAuthentication().isDeviceSupported();
                      if(isSupported){
                        setState(() {
                          biometricProvider.switchBiometricPrefs();
                        });
                      }
                      else{
                        showCustomSnackbar(context, 'This device does not support biometric authentication');
                      }
                    },
                    inactiveThumbColor: color.onPrimary,
                    inactiveTrackColor: color.onSurface,
                    activeColor: color.primary,
                    title: Text(
                      'Biometrics',
                      style: TextStyle(
                        color: color.onPrimary,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }
                else if(snapshot.hasError){
                  log('Error: ${snapshot.error}');
                  return const SizedBox();
                }
                else{
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

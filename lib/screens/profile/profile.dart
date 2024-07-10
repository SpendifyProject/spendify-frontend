import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/routes.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:spendify/screens/payment_methods/all_accounts.dart';
import 'package:spendify/widgets/error_dialog.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserProvider userProvider;
  bool isLoading = true;
  String email = auth.FirebaseAuth.instance.currentUser!.email.toString();

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              color: color.onPrimary,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: color.onPrimary,
              size: 20,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, editProfileRoute);
              },
              icon: Icon(
                Icons.edit_outlined,
                color: color.onPrimary,
                size: 20,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: userProvider.getUserData(email),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              isLoading = true;
              return const SizedBox();
            } else if (snapshot.hasError) {
              showErrorDialog(context, 'Error: ${snapshot.error}');
            } else {
              isLoading = false;
              final User user = userProvider.user;
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 25.h,
                  horizontal: 20.w,
                ),
                child: ListView(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipOval(
                        child: Image.network(
                          user.imagePath,
                          width: 50.w,
                          height: 50.h,
                        ),
                      ),
                      title: Text(
                        user.fullName,
                        style: TextStyle(
                          color: color.onPrimary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.person_outline,
                        color: color.secondary,
                        size: 20,
                      ),
                      title: Text(
                        'Personal Information',
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
                      height: 10.h,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        CupertinoIcons.money_dollar_circle,
                        color: color.secondary,
                        size: 20,
                      ),
                      title: Text(
                        'Payment Preferences',
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
                      height: 10.h,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AllCards(
                                user: user,
                              );
                            },
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.wallet_outlined,
                        color: color.secondary,
                        size: 20,
                      ),
                      title: Text(
                        'Cards and Mobile Money',
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
                      height: 10.h,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.notifications_none,
                        color: color.secondary,
                        size: 20,
                      ),
                      title: Text(
                        'Notifications',
                        style: TextStyle(
                          color: color.onPrimary,
                          fontSize: 14,
                        ),
                      ),
                      trailing: Badge(
                        backgroundColor: color.tertiary,
                        label: const Text('2'),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ));
  }
}

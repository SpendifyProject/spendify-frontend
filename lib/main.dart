import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/dark_theme.dart';
import 'package:spendify/const/routes.dart';
import 'package:spendify/const/theme.dart';
import 'package:spendify/provider/theme_provider.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:spendify/provider/wallet_provider.dart';
import 'package:spendify/screens/auth/sign_in.dart';
import 'package:spendify/screens/auth/sign_up.dart';
import 'package:spendify/screens/dashboard/dashboard.dart';
import 'package:spendify/screens/dashboard/settings/change_password.dart';
import 'package:spendify/screens/dashboard/settings/conditions.dart';
import 'package:spendify/screens/dashboard/settings/contact.dart';
import 'package:spendify/screens/dashboard/settings/privacy_policy.dart';
import 'package:spendify/screens/onboarding/onboarding_1.dart';
import 'package:spendify/screens/profile/edit_profile.dart';
import 'package:spendify/screens/profile/profile.dart';
import 'package:spendify/screens/transactions/search.dart';
import 'package:spendify/screens/transactions/transaction_history.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
  FlutterNativeSplash.remove();
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WalletProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Spendify',
            theme: themeProvider.darkTheme
                ? darkThemeData(context)
                : themeData(context),
            debugShowCheckedModeBanner: false,
            routes: {
              signInRoute: (context) => const SignIn(),
              signUpRoute: (context) => const SignUp(),
              profileRoute: (context) => const Profile(),
              editProfileRoute: (context) => const EditProfile(),
              searchRoute: (context) => const Search(),
              transactionsRoute: (context) => const Transactions(),
              contactRoute: (context) => const Contact(),
              changePasswordRoute: (context) => const ChangePassword(),
              privacyRoute: (context) => const PrivacyPolicy(),
              conditionsRoute: (context) => const TermsAndConditions(),
            },
            home: FirebaseAuth.instance.currentUser == null
                ? const Onboarding1()
                : Dashboard(
                    email: FirebaseAuth.instance.currentUser!.email.toString(),
                  ),
          );
        },
      ),
    );
  }
}

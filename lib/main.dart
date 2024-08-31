import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/dark_theme.dart';
import 'package:spendify/const/routes.dart';
import 'package:spendify/const/theme.dart';
import 'package:spendify/provider/biometric_provider.dart';
import 'package:spendify/provider/savings_provider.dart';
import 'package:spendify/provider/theme_provider.dart';
import 'package:spendify/provider/transaction_provider.dart';
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
import 'package:spendify/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  //Initialize flutter native splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //Initialize local notifications
  tz.initializeTimeZones();
  await NotificationService.init();

  //Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, child) => const MyApp(),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => WalletProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => SavingsProvider()),
        ChangeNotifierProvider(create: (context) => BiometricProvider()),
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

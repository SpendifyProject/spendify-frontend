import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static Future<void> authenticate(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final isAvailable = await auth.isDeviceSupported();
      if (!isAvailable) {
        throw 'Device does not support biometric authentication';
      }

      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to unlock the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if(didAuthenticate){
        log('Auth successful');
        print('Auth successful');
        Navigator.pop(context);
      }
      else{
        log('Auth failed');
        print('Auth failed');
      }
    } catch (error) {
      log('Error during biometric authentication: $error');
      rethrow;
    }
  }
}

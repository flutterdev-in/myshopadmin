import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:getwidget/getwidget.dart';
import 'package:myshopadmin/firebase_options.dart';
import 'package:myshopadmin/services/firebase_objects.dart';

import '_home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(showAuthActionSwitch: false, providerConfigs: [
            GoogleProviderConfiguration(
              clientId: DefaultFirebaseOptions.web.appId,
            ),
          ]);
        } else if (snapshot.hasData &&
            fireUser().email == "mvphaneendra@gmail.com") {
          // Render your application if authenticated
          return const HomePage();
        } else {
          return const UnAuthorizedLogin();
        }
      },
    );
  }
}

class UnAuthorizedLogin extends StatelessWidget {
  const UnAuthorizedLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("You are not authorized, to access this website"),
          GFButton(
            onPressed: () {
              fireLogOut();
            },
            child: const Text("Logout"),
          )
        ],
      )),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopadmin/custom%20widgets/stream_builder_widget.dart';
import 'package:myshopadmin/services/fire_admin.dart';
import 'package:myshopadmin/services/firebase_objects.dart';

import '_home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return const GoogleSignInScreen();
        } else {
          // Render your application if authenticated

          return StreamDocBuilder(
              stream: adminGmailsDR,
              loadingW: UnAuthorizedLogin(false),
              errorW: UnAuthorizedLogin(false),
              noResultsW: UnAuthorizedLogin(true),
              builder: (context, snapshot) {
                var gmails = snapshot.data()?[fa.gmails] as List;
                if (gmails
                    .contains(fireUser().email?.replaceAll("@gmail.com", ""))) {
                  return const HomeScreen();
                }
                return UnAuthorizedLogin(true);
              });
        }
      },
    );
  }
}

class GoogleSignInScreen extends StatelessWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("My Shop Admin"),
            InkWell(
              child: SizedBox(
                height: 60,
                width: Get.width - 60,
                child: Card(
                  child: Row(
                    children: const [
                      SizedBox(width: 12),
                      Icon(MdiIcons.google),
                      SizedBox(width: 12),
                      Text("Continue with Google", textScaleFactor: 1.3),
                    ],
                  ),
                ),
              ),
              onTap: () {
                googleLoginFunction();
              },
            ),
          ],
        ),
      ),
    );
  }
}

//

Future<void> googleLoginFunction() async {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  if (kIsWeb) {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    await FirebaseAuth.instance.signOut();

    await FirebaseAuth.instance
        // .signInWithRedirect(googleProvider)
        .signInWithPopup(googleProvider)
        .then((user) async {
      Get.snackbar("login", "success");
    }).catchError((e) {
      Get.snackbar("Error while login", "Please try again");
    });
  } else {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    try {
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await FirebaseAuth.instance.signOut();

        await firebaseAuth
            .signInWithCredential(oAuthCredential)
            .then((user) async {
          Get.snackbar("login", "success");
        }).catchError((e) {
          Get.snackbar("Error while login", "Please try again");
        });

        Get.back();
      }
    } catch (error) {
      Get.snackbar("Error while login", "Please try again");
    }
  }
}

//

class UnAuthorizedLogin extends StatelessWidget {
  bool isUnAuth;
  UnAuthorizedLogin(this.isUnAuth, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(isUnAuth
                ? "You are not authorized, to access this website"
                : "Loading please wait...."),
          ),
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

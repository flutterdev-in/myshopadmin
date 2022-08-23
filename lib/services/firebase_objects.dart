import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';


const authUsers = "authUsers";
const nonAuthUsers = "nonAuthUsers";

final authUserCR = FirebaseFirestore.instance.collection(authUsers);
final nonAuthUserCR = FirebaseFirestore.instance.collection(nonAuthUsers);




//
User fireUser() {
  return FirebaseAuth.instance.currentUser!;
}

Future<void> fireLogOut() async {
  await Future.delayed(const Duration(milliseconds: 300));
  if (!kIsWeb) {
    await GoogleSignIn().disconnect();
  }

  await FirebaseAuth.instance.signOut();
}

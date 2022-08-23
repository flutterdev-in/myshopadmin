import 'package:cloud_firestore/cloud_firestore.dart';

FireAdmin fa = FireAdmin();

class FireAdmin{
 final adminGmails = "adminGmails";
 final gmails = "gmails";
  final adminCR = FirebaseFirestore.instance.collection("adminDocs");
  
}

final adminGmailsDR = fa.adminCR.doc(fa.adminGmails);
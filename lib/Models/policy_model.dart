import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myshopadmin/Screens/Policies/edit_main_policy.dart';
import 'package:myshopadmin/services/fire_admin.dart';

class PolicyModel {
  List<Policy>? listPoliy;
  String heading;
  bool isPrimePolicy;

  DocumentReference<Map<String, dynamic>>? docRef;

  PolicyModel({
    required this.listPoliy,
    required this.heading,
    required this.isPrimePolicy,
  });

  Map<String, dynamic> toMap() {
    return {
      policyMOs.heading: heading,
      policyMOs.listPoliy: listPoliy?.map((e) => e.toMap()).toList(),
      policyMOs.isPrimePolicy: isPrimePolicy,
    };
  }

  factory PolicyModel.fromMap(Map<String, dynamic> policyMap) {
    var listP = policyMap[policyMOs.listPoliy] as List?;
    return PolicyModel(
      heading: policyMap[policyMOs.heading] ?? "",
      listPoliy: listP?.map((e) => Policy.fromMap(e)).toList(),
      isPrimePolicy: policyMap[policyMOs.isPrimePolicy] ?? false,
    );
  }
}

PolicyModelObjects policyMOs = PolicyModelObjects();

class PolicyModelObjects {
  final heading = "heading";
  final name = "name";
  final description = "description";
  final collections = "collections";
  final policies = "policies";
  final listPoliy = "listPoliy";
  final isPrimePolicy = "isPrimePolicy";

  CollectionReference<Map<String, dynamic>> policiesCR() {
    return fa.adminCR.doc(collections).collection(policies);
  }

  Future<void> addPolicy(bool isPrime) async {
    var pm = PolicyModel(
      listPoliy: null,
      heading: "dummy",
      isPrimePolicy: isPrime,
    );
    await policiesCR()
        .add(
      pm.toMap(),
    )
        .then((dr) {
      pm.docRef = dr;
      Get.to(() => EditMainPolicy(pm));
    });
  }
}

class Policy {
  String name;

  String description;

  Policy({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      policyMOs.name: name,
      policyMOs.description: description,
    };
  }

  factory Policy.fromMap(Map<String, dynamic> policyMap) {
    return Policy(
      name: policyMap[policyMOs.name] ?? "",
      description: policyMap[policyMOs.description] ?? "",
    );
  }
}

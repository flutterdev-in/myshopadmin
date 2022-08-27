import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myshopadmin/services/fire_admin.dart';

class PolicyModel {
  List<Policy>? listPoliy;
  String heading;

  DocumentReference<Map<String, dynamic>>? docRef;

  PolicyModel({

    required this.listPoliy,
    required this.heading,
  });

  Map<String, dynamic> toMap() {
    return {

      policyMOs.heading: heading,
      policyMOs.listPoliy: listPoliy?.map((e) => e.toMap()).toList(),
    };
  }

  factory PolicyModel.fromMap(Map<String, dynamic> policyMap) {
    var listP = policyMap[policyMOs.listPoliy] as List?;
    return PolicyModel(
  
      heading: policyMap[policyMOs.heading] ?? "",
      listPoliy: listP?.map((e) => Policy.fromMap(e)).toList(),
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

  CollectionReference<Map<String, dynamic>> policiesCR() {
    return fa.adminCR.doc(collections).collection(policies);
  }

  Future<void> addPolicy() async {
    await policiesCR().add(
      PolicyModel(listPoliy: null, heading: "dummy").toMap(),
    );
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

import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'prime_member_model.dart';

class KycModel {
  String userName;
  String? aadhaarUrl;
  String? panCardUrl;
  String? checkOrPassbookUrl;
  String? accountNumber;
  String? ifsc;
  String? bankName;
  DateTime? updatedTime;
  String aadhaarStatus;
  String panCardStatus;
  String checkOrPassbookStatus;
  String accountNumberStatus;
  String ifscStatus;
  String? adminComments;
  bool? isKycVerified;
  DocumentReference<Map<String, dynamic>>? docRef;

  KycModel({
    required this.userName,
    required this.aadhaarUrl,
    required this.panCardUrl,
    required this.checkOrPassbookUrl,
    required this.accountNumber,
    required this.ifsc,
    required this.bankName,
    required this.updatedTime,
    this.ifscStatus = "",
    this.aadhaarStatus = "",
    this.panCardStatus = "",
    this.checkOrPassbookStatus = "",
    this.accountNumberStatus = "",
    required this.isKycVerified,
    this.adminComments,
    this.docRef,
  });

  Map<String, dynamic> toMap() {
    var km = KycModel(
      updatedTime: DateTime.now(),
      userName: userName,
      aadhaarUrl: aadhaarUrl,
      panCardUrl: panCardUrl,
      checkOrPassbookUrl: checkOrPassbookUrl,
      accountNumber: accountNumber,
      ifsc: ifsc,
      bankName: bankName,
      ifscStatus: ifscStatus,
      aadhaarStatus: aadhaarStatus,
      panCardStatus: panCardStatus,
      checkOrPassbookStatus: checkOrPassbookStatus,
      accountNumberStatus: accountNumberStatus,
      adminComments: adminComments,
      isKycVerified: false,
    );

    return {
      primeMOs.userName: userName,
      kycMOs.aadhaarUrl: aadhaarUrl,
      kycMOs.panCardUrl: panCardUrl,
      kycMOs.checkOrPassbookUrl: checkOrPassbookUrl,
      kycMOs.accountNumber: accountNumber,
      kycMOs.ifsc: ifsc,
      kycMOs.ifscStatus: ifscStatus,
      kycMOs.aadhaarStatus: aadhaarStatus,
      kycMOs.updatedTime: updatedTime,
      kycMOs.panCardStatus: panCardStatus,
      kycMOs.checkOrPassbookStatus: checkOrPassbookStatus,
      kycMOs.accountNumberStatus: accountNumberStatus,
      kycMOs.adminComments: adminComments,
      kycMOs.isKycVerified: kycMOs.isKycVrf(km),
    };
  }

  factory KycModel.fromMap(Map<String, dynamic> kycMap) {
    var km = KycModel(
      userName: kycMap[primeMOs.userName],
      aadhaarUrl: kycMap[kycMOs.aadhaarUrl],
      panCardUrl: kycMap[kycMOs.panCardUrl],
      checkOrPassbookUrl: kycMap[kycMOs.checkOrPassbookUrl],
      accountNumber: kycMap[kycMOs.accountNumber],
      ifsc: kycMap[kycMOs.ifsc],
      updatedTime: kycMap[kycMOs.updatedTime]?.toDate(),
      ifscStatus: kycMap[kycMOs.ifscStatus] ?? "",
      bankName: kycMap[kycMOs.bankName],
      aadhaarStatus: kycMap[kycMOs.aadhaarStatus] ?? "",
      panCardStatus: kycMap[kycMOs.panCardStatus] ?? "",
      checkOrPassbookStatus: kycMap[kycMOs.checkOrPassbookStatus] ?? "",
      accountNumberStatus: kycMap[kycMOs.accountNumberStatus] ?? "",
      isKycVerified: kycMap[kycMOs.isKycVerified],
      adminComments: kycMap[kycMOs.adminComments],
    );
    km.isKycVerified = kycMOs.isKycVrf(km);
    return km;
  }
}

KycModelObjects kycMOs = KycModelObjects();

class KycModelObjects {
  final aadhaarUrl = "aadhaarUrl";
  final panCardUrl = "panCardUrl";
  final accountNumber = "accountNumber";
  final accountNumberStatus = "accountNumberStatus";
  final ifsc = "ifsc";
  final ifscStatus = "ifscStatus";
  final checkOrPassbookUrl = "checkOrPassbookUrl";
  final bankName = "bankName";
  final aadhaarStatus = "aadhaarStatus";
  final panCardStatus = "panCardStatus";
  final checkOrPassbookStatus = "checkOrPassbookStatus";
  final isKycVerified = "isKycVerified";
  final kyc = "kyc";
  final adminComments = "adminComments";
  final updatedTime = "updatedTime";

  //
  final verified = "verified";
  final invalid = "invalid";
  final uploaded = "uploaded";

  //
  DocumentReference<Map<String, dynamic>> kycDR(String userName) {
    return kycCR().doc(userName);
  }

  //
  CollectionReference<Map<String, dynamic>> kycCR() {
    return FirebaseFirestore.instance.collection(kyc);
  }

  bool isKycVrf(KycModel km) {
    bool isAllUploaded = (km.aadhaarUrl != null &&
        km.panCardUrl != null &&
        km.checkOrPassbookUrl != null &&
        km.accountNumber != null &&
        km.ifsc != null &&
        km.bankName != null);
    bool isAllVerified = (km.aadhaarStatus == kycMOs.verified &&
        km.panCardStatus == kycMOs.verified &&
        km.checkOrPassbookStatus == kycMOs.verified &&
        km.accountNumberStatus == kycMOs.verified);

    return isAllUploaded && isAllVerified;
  }

  //
  Future<bool?> isPrimeKycVerified(String userName) async {
    return await kycDR(userName).get().then((ds) {
      if (ds.exists && ds.data() != null) {
        var km = KycModel.fromMap(ds.data()!);
        return km.isKycVerified;
      }
      return null;
    });
  }

  String? getCorresBoolName(String name) {
    if (name == aadhaarUrl) {
      return aadhaarStatus;
    } else if (name == panCardUrl) {
      return panCardStatus;
    } else if (name == checkOrPassbookUrl) {
      return checkOrPassbookStatus;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getIFSCmap(String ifsc) async {
    if (ifsc.contains(RegExp(r'^[A-Z]{4}0[0-9]{6}$'))) {
      var url = Uri.parse("https://ifsc.razorpay.com/$ifsc");
      Response response = await http.get(url);
      // print(response.body);
      if (response.statusCode == 200 && response.body != "Not Found") {
        Map<String, dynamic> dataMap = jsonDecode(response.body);
        return dataMap;
      }
    }
    return null;
  }

  Future<String?> getIFSCdetails(String ifsc) async {
    var dataMap = await getIFSCmap(ifsc);
    if (dataMap != null) {
      return "Bank : ${dataMap['BANK']}\nBranch : ${dataMap['BRANCH']}\nAddress : ${dataMap['ADDRESS']}";
    }
    return null;
  }

  Future<String?> getIFSCbank(String ifsc) async {
    var dataMap = await getIFSCmap(ifsc);
    if (dataMap != null) {
      return dataMap['BANK'].toString();
    }
    return null;
  }
}

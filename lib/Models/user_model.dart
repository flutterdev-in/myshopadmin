
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../dart/const_global_objects.dart';
import '../services/hive_boxes.dart';


class UserModel {
  int? memberPosition;
  String profileName;
  String? memberID;
  String userEmail;
  String? phoneNumber;
  String? refMemberId;
  String? profilePhotoUrl;
  DateTime? paymentTime;
  int directIncome;
  String? fcmToken;
  DateTime? firstLoginTime;
  DocumentReference<Map<String, dynamic>>? docRef;

  UserModel({
    required this.memberPosition,
    required this.profileName,
    required this.memberID,
    required this.userEmail,
    required this.phoneNumber,
    required this.refMemberId,
    required this.profilePhotoUrl,
    required this.paymentTime,
    required this.directIncome,
    required this.fcmToken,
    required this.firstLoginTime,
    this.docRef,
  });

  Map<String, dynamic> toMap() {
    return {
      userMOs.memberPosition: memberPosition,
      userMOs.profileName: profileName,
      userMOs.userEmail: userEmail,
      userMOs.phoneNumber: phoneNumber,
      userMOs.memberID: memberID,
      userMOs.refMemberId: refMemberId,
      userMOs.paymentTime:
          paymentTime != null ? Timestamp.fromDate(DateTime.now()) : null,
      userMOs.directIncome: directIncome,
      userMOs.firstLoginTime:
          Timestamp.fromDate(firstLoginTime ?? DateTime.now()),
      unIndexed: {
        userMOs.profilePhotoUrl: profilePhotoUrl,
        boxStrings.fcmToken: fcmToken,
      }
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> userMap) {
    return UserModel(
      memberPosition: userMap[userMOs.memberPosition],
      profileName: userMap[userMOs.profileName] ?? "",
      memberID: userMap[userMOs.memberID],
      userEmail: userMap[userMOs.userEmail] ?? "",
      phoneNumber: userMap[userMOs.phoneNumber],
      refMemberId: userMap[userMOs.refMemberId],
      paymentTime: userMap[userMOs.paymentTime]?.toDate(),
      directIncome: userMap[userMOs.directIncome] ?? 0,
      firstLoginTime: userMap[userMOs.firstLoginTime]?.toDate(),
      profilePhotoUrl: userMap[unIndexed] != null
          ? userMap[unIndexed][userMOs.profilePhotoUrl]
          : null,
      fcmToken: userMap[unIndexed] != null
          ? userMap[unIndexed][boxStrings.fcmToken]
          : null,
    );
  }
}

UserModelObjects userMOs = UserModelObjects();

class UserModelObjects {
  final memberPosition = "memberPosition";
  final profileName = "profileName";
  final memberID = "memberID";
  final userEmail = "userEmail";
  final phoneNumber = "phoneNumber";
  final refMemberId = "refMemberId";
  final profilePhotoUrl = "profilePhotoUrl";
  final downLevelEndPositions = "downLevelEndPositions";
  final directIncome = "directIncome";
  final matrixIncome = "matrixIncome";
  final directWalletHistory = "directWalletHistory";
  final matrixIncomeHistory = "matrixIncomeHistory";
  final paymentTime = "paymentTime";
  final docs = "docs";
  final payment = "payment";
  final firstLoginTime = "firstLoginTime";



  //
  String dateTime(DateTime time) {
    String ampm = DateFormat("a").format(time).toLowerCase();
    String chatDayTime = DateFormat("dd MMM").format(time);
    //
    String today = DateFormat("dd MMM").format(DateTime.now());
    // String chatDay =
    //     DateFormat("dd MMM").format(crm.lastChatModel!.senderSentTime);

    if (today == chatDayTime) {
      chatDayTime = DateFormat("h:mm").format(time) + ampm;
    }
    return chatDayTime;
  }

  Future<void> onPaymentFunctionCall(String userUID) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable("on_payment");
    await callable.call(<String>[userUID]);
  }


  void shareRefLink(UserModel? um) {
    if (um != null && um.memberID != null && um.memberPosition != null) {
      Share.share("https://myshopau.com/referral/${um.memberID}");
    } else {
      Get.snackbar("Network error", "Please try again");
    }
  }
}

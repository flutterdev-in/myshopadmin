import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:share_plus/share_plus.dart';

class PrimeMemberModel {
  int? memberPosition;
  String? name;
  String? firstName;
  String? lastName;
  String? memberID;
  String? email;
  String? phoneNumber;
  String? refMemberId;
  DateTime? paymentTime;
  int directIncome;

  String? orderID;
  bool? isPaid;
  String? interestedIn;
  String? userName;
  String? userPassword;
  String? profilePhotoUrl;
  String? fcmToken;

  DocumentReference<Map<String, dynamic>>? docRef;

  PrimeMemberModel({
    required this.memberPosition,
    this.name,
    required this.firstName,
    required this.lastName,
    required this.memberID,
    required this.email,
    required this.phoneNumber,
    required this.refMemberId,
    required this.paymentTime,
    required this.directIncome,
    required this.orderID,
    required this.isPaid,
    required this.interestedIn,
    required this.userName,
    required this.userPassword,
    required this.profilePhotoUrl,
    required this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    return {
      primeMOs.memberPosition: memberPosition,
      primeMOs.firstName: firstName,
      primeMOs.lastName: lastName,
      primeMOs.memberID: memberID,
      primeMOs.email: email,
      primeMOs.phoneNumber: phoneNumber,
      primeMOs.refMemberId: refMemberId,
      primeMOs.paymentTime: paymentTime,
      primeMOs.directIncome: directIncome,
      primeMOs.orderID: orderID,
      primeMOs.isPaid: isPaid,
      primeMOs.interestedIn: interestedIn,
      primeMOs.userName: userName,
      primeMOs.userPassword: userPassword,
      primeMOs.profilePhotoUrl: profilePhotoUrl,
      "fcmToken": fcmToken,
    };
  }

  factory PrimeMemberModel.fromMap(Map<String, dynamic> userMap) {
    var fn = userMap[primeMOs.firstName] as String?;
    var ln = userMap[primeMOs.lastName] as String?;
    return PrimeMemberModel(
      memberPosition: userMap[primeMOs.memberPosition],
      name: "${fn ?? ''} ${ln ?? ''}",
      firstName: userMap[primeMOs.firstName],
      lastName: userMap[primeMOs.lastName],
      memberID: userMap[primeMOs.memberID],
      email: userMap[primeMOs.email],
      phoneNumber: userMap[primeMOs.phoneNumber],
      refMemberId: userMap[primeMOs.refMemberId],
      paymentTime: userMap[primeMOs.paymentTime]?.toDate(),
      directIncome: userMap[primeMOs.directIncome] ?? 0,
      orderID: userMap[primeMOs.orderID],
      isPaid: userMap[primeMOs.isPaid],
      interestedIn: userMap[primeMOs.interestedIn],
      userName: userMap[primeMOs.userName],
      userPassword: userMap[primeMOs.userPassword],
      profilePhotoUrl: userMap[primeMOs.profilePhotoUrl],
      fcmToken: userMap[primeMOs.fcmToken],
    );
  }
}

PrimeMemberModelObjects primeMOs = PrimeMemberModelObjects();

class PrimeMemberModelObjects {
  final memberPosition = "memberPosition";
  final firstName = "firstName";
  final lastName = "lastName";
  final memberID = "memberID";
  final email = "email";
  final phoneNumber = "phoneNumber";
  final refMemberId = "refMemberId";
  final paymentTime = "paymentTime";
  final directIncome = "directIncome";
  final fcmToken = "fcmToken";
  final orderID = "orderID";
  final isPaid = "isPaid";
  final interestedIn = "interestedIn";
  final userName = "userName";
  final userPassword = "userPassword";
  final profilePhotoUrl = "profilePhotoUrl";

  //

  final primeMembers = "primeMembers";

  //
  final amount = 100000;
  // final razorpay = Razorpay();
  final razorKey = "rzp_live_yCBJw6q6PHaIpJ";

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

  CollectionReference<Map<String, dynamic>> primeMembersCR() {
    return FirebaseFirestore.instance.collection(primeMembers);
  }

  Future<void> addPrimePosition(PrimeMemberModel pmm) async {
    if (pmm.userName != null &&
        pmm.memberPosition == null &&
        pmm.isPaid == true &&
        pmm.refMemberId != null &&
        pmm.memberID != null) {
      HttpsCallable addPos =
          FirebaseFunctions.instance.httpsCallable('add_prime_position');
      await addPos.call(<String, dynamic>{
        "uid": pmm.userName!,
      });
    } else {
      Get.snackbar("Error", "Invalid user credentials");
    }
  }

  Future<PrimeMemberModel?> getPrimeMemberModel(String userName0) async {
    return primeMembersCR().doc(userName).get().then((ds) {
      if (ds.exists && ds.data() != null) {
        var pmm = PrimeMemberModel.fromMap(ds.data()!);
        pmm.docRef = ds.reference;
        return pmm;
      }
      return null;
    });
  }

  //
  Future<PrimeMemberModel?> getLastPrimeMemberModel() async {
    return primeMembersCR()
        .orderBy(primeMOs.memberPosition, descending: true)
        .limit(1)
        .get()
        .then(((qs) {
      if (qs.docs.isNotEmpty) {
        return PrimeMemberModel.fromMap(qs.docs.first.data());
      }
      return null;
    }));
  }

  //

  DocumentReference<Map<String, dynamic>> primeMemberDR(String userName0) {
    return primeMembersCR().doc(userName0);
  }

  void shareRefLink(PrimeMemberModel? pmm) {
    if (pmm != null && pmm.memberID != null && pmm.memberPosition != null) {
      Share.share("https://myshopau.com/referral/${pmm.memberID}");
    } else {
      Get.snackbar("Network error", "Please try again");
    }
  }

  Future<bool> checkUpdateAndGetOrderStatus(String userName) async {
    var isPaid = false;
    await primeMemberDR(userName).get().then((ds) async {
      if (ds.exists && ds.data() != null) {
        var pmm = PrimeMemberModel.fromMap(ds.data()!);
        pmm.docRef = ds.reference;

        if (pmm.orderID != null && pmm.isPaid != true) {
          HttpsCallable checkOrderStatus =
              FirebaseFunctions.instance.httpsCallable('orderStutus');
          var status = await checkOrderStatus.call(<String, dynamic>{
            "orderId": pmm.orderID,
          });
          if (status.data == "paid") {
            isPaid = true;
            pmm.isPaid = true;
            await addPrimePosition(pmm);
            await pmm.docRef!.update(pmm.toMap());
          } else if (pmm.isPaid == null && (status.data == "attempted")) {
            pmm.isPaid = false;
            await pmm.docRef!.update(pmm.toMap());
          }
        }
      }
    });
    return isPaid;
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:myshopadmin/Models/kyc_model.dart';
import 'package:myshopadmin/Models/prime_member_model.dart';
import 'package:myshopadmin/custom%20widgets/firestore_listview_builder.dart';
import 'package:myshopadmin/custom%20widgets/stream_builder_widget.dart';
import 'package:myshopadmin/dart/useful_functions.dart';
import 'package:myshopadmin/z_Prime_screens/kyc%20pages/a_kyc_verification_page.dart';

import '../../matrix/positions.dart';

class KycHomePage extends StatefulWidget {
  const KycHomePage({Key? key}) : super(key: key);

  @override
  State<KycHomePage> createState() => _KycHomePageState();
}

class _KycHomePageState extends State<KycHomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabC;
  @override
  void initState() {
    super.initState();
    tabC = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("KYC"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(36.0),
            child: TabBar(
              controller: tabC,
              indicatorColor: Colors.white70,
              tabs: const [
                SizedBox(height: 30, child: Center(child: Text("Un Verified"))),
                SizedBox(height: 30, child: Center(child: Text("Verified"))),
              ],
              indicatorWeight: 2.5,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: TabBarView(
          controller: tabC,
          children: [
            kycMembers(false),
            kycMembers(true),
          ],
        ),
      ),
    );
  }

  Widget kycMembers(bool isKycVerified) {
    return FirestoreListViewBuilder(
      query: kycMOs
          .kycCR()
          .where(kycMOs.isKycVerified, isEqualTo: isKycVerified)
          .orderBy(kycMOs.updatedTime, descending: true),
      builder: (snapshot) {
        var km = KycModel.fromMap(snapshot.data());
        km.docRef = snapshot.reference;
        return StreamDocBuilder(
            stream: primeMOs.primeMemberDR(km.userName),
            builder: (context, snapshot) {
              var pmm = PrimeMemberModel.fromMap(snapshot.data()!);
              return GFListTile(
                title: Text(
                  pmm.name ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subTitle: Text(
                  "Updated on ${km.updatedTime != null ? timeString(km.updatedTime!) : 'null'}",
                  textScaleFactor: 0.9,
                ),
                icon: Text(
                    "r${rowNumber(pmm.memberPosition ?? 0) + 1}p${rowPosition(pmm.memberPosition!)} = ${pmm.memberPosition}"),
                avatar: GFAvatar(
                  backgroundImage: pmm.profilePhotoUrl != null
                      ? CachedNetworkImageProvider(pmm.profilePhotoUrl!)
                      : null,
                ),
                onTap: () {
                  Get.to(() => KycVerificationPage(km, pmm));
                },
              );
            });
      },
    );
  }
}

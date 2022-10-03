import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:myshopadmin/custom%20widgets/firestore_listview_builder.dart';
import 'package:myshopadmin/z_Prime_screens/x_member_dashboard.dart';

import '../Models/prime_member_model.dart';
import '../dart/repeatFunctions.dart';

class NonPrmeMembersPage extends StatelessWidget {
  const NonPrmeMembersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Non Prime members"),
      ),
      body: Column(
        children: const [
          Expanded(child: ListPrime()),
        ],
      ),
    );
  }
}

class ListPrime extends StatelessWidget {
  const ListPrime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreListViewBuilder(
        query: primeMOs
            .primeMembersCR()
            .where(primeMOs.memberPosition, isNull: true),
        builder: (qds) {
          var pmm = PrimeMemberModel.fromMap(qds.data());
          pmm.docRef = qds.reference;
          return GFListTile(
            title: Text(
              pmm.name ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subTitleText: "${pmm.phoneNumber}\n${pmm.userName}",
            avatar: GFAvatar(
              backgroundImage: pmm.profilePhotoUrl != null
                  ? CachedNetworkImageProvider(pmm.profilePhotoUrl!)
                  : null,
            ),
            onTap: () async {
              await waitMilli();
              Get.to(() => MemberDashboard(pmm, false, true));
            },
          );
        });
  }
}

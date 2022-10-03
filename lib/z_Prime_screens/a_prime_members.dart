import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myshopadmin/Models/prime_member_model.dart';
import 'package:myshopadmin/custom%20widgets/firestore_listview_builder.dart';
import 'package:myshopadmin/custom%20widgets/stream_single_query_builder.dart';
import 'package:myshopadmin/dart/repeatFunctions.dart';
import 'package:myshopadmin/z_Prime_screens/aa_prime_each_member.dart';

import '../matrix/matrix_income.dart';
import '../matrix/positions.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PrmeMembersPage extends StatelessWidget {
  const PrmeMembersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rowPos = 0.obs;
    var descending = true.obs;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prime members"),
        actions: [
          IconButton(
              onPressed: () {
                descending.value = !descending.value;
              },
              icon: Obx(() =>
                  Icon(descending.value ? MdiIcons.details : MdiIcons.delta))),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
              height: 50,
              width: Get.width,
              child: StreamSingleQueryBuilder(
                stream: primeMOs
                    .primeMembersCR()
                    .orderBy(primeMOs.memberPosition, descending: true),
                builder: (context, snapshot) {
                  var pmm = PrimeMemberModel.fromMap(snapshot.data());
                  int rowNum = rowNumber(pmm.memberPosition ?? 0);
                  List<int> listRow = [for (var i = 0; i <= rowNum; i++) i];
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listRow.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            GFIconButton(
                                highlightColor: Colors.red.shade200,
                                color: Colors.blueGrey.shade300,
                                onPressed: () {
                                  rowPos.value = index;
                                },
                                icon: Text("r${index + 1}")),
                            const SizedBox(width: 5),
                          ],
                        );
                      });
                },
              )),
          Expanded(
            child: Obx(() => FirestoreListViewBuilder(
                query: rowPos.value == 0
                    ? primeMOs
                        .primeMembersCR()
                        .where(primeMOs.memberPosition, isNull: false)
                        .orderBy(primeMOs.memberPosition,
                            descending: descending.value)
                    : primeMOs
                        .primeMembersCR()
                        .where(primeMOs.memberPosition,
                            isGreaterThanOrEqualTo:
                                getPosition(rowPos.value, 1))
                        .where(primeMOs.memberPosition,
                            isLessThan: getPosition(rowPos.value + 1, 1))
                        .orderBy(primeMOs.memberPosition,
                            descending: descending.value),
                builder: (qds) {
                  var pmm = PrimeMemberModel.fromMap(qds.data());
                  pmm.docRef = qds.reference;
                  return StreamSingleQueryBuilder(
                      stream: primeMOs
                          .primeMembersCR()
                          .where(primeMOs.memberPosition, isNull: false)
                          .orderBy(primeMOs.memberPosition, descending: true),
                      builder: (context, snapshot) {
                        var pmmLast = PrimeMemberModel.fromMap(snapshot.data());
                        return GFListTile(
                          title: Text(
                            pmm.name ?? "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subTitleText:
                              "(${pmm.userName})\nRefreral : ${pmm.directIncome * 500}\nMatrix : ${matrixIncome(pmm.memberPosition!, pmmLast.memberPosition!)}",
                          icon: Text(
                              "r${rowNumber(pmm.memberPosition ?? 0) + 1}p${rowPosition(pmm.memberPosition!)} = ${pmm.memberPosition}"),
                          avatar: GFAvatar(
                            backgroundImage: pmm.profilePhotoUrl != null
                                ? CachedNetworkImageProvider(
                                    pmm.profilePhotoUrl!)
                                : null,
                          ),
                          onTap: () async {
                            await waitMilli();
                            Get.to(() => PrimeMemberEachPage(pmm));
                          },
                        );
                      });
                })),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:myshopadmin/Models/prime_member_model.dart';
import 'package:myshopadmin/custom%20widgets/firestore_listview_builder.dart';
import 'package:myshopadmin/custom%20widgets/stream_single_query_builder.dart';

import '../matrix/matrix_income.dart';
import '../matrix/positions.dart';

class PrmeMembersPage extends StatelessWidget {
  const PrmeMembersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prime members"),
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
            .where(primeMOs.memberPosition, isNull: false)
            .orderBy(primeMOs.memberPosition, descending: false),
        builder: (p0, qds) {
          var pmm = PrimeMemberModel.fromMap(qds.data());
          return StreamSingleQueryBuilder(
              query: primeMOs
                  .primeMembersCR()
                  .where(primeMOs.memberPosition, isNull: false)
                  .orderBy(primeMOs.memberPosition, descending: true),
              docBuilder: (context, snapshot) {
                var pmmLast = PrimeMemberModel.fromMap(snapshot.data());
                return GFListTile(
                  title: Text(
                    pmm.name ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subTitleText:
                      "Direct : ${pmm.directIncome * 500}\nMatrix : ${matrixIncome(pmm.memberPosition!, pmmLast.memberPosition!)}",
                  icon: Text(
                      "r${rowNumber(pmm.memberPosition ?? 0) + 1}p${rowPosition(pmm.memberPosition!)} = ${pmm.memberPosition}"),
                  avatar: GFAvatar(
                    backgroundImage: pmm.profilePhotoUrl != null
                        ? CachedNetworkImageProvider(pmm.profilePhotoUrl!)
                        : null,
                  ),
                );
              });
        });
  }
}

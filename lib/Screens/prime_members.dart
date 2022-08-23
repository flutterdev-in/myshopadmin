import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:myshopadmin/Models/user_model.dart';
import 'package:myshopadmin/custom%20widgets/firestore_listview_builder.dart';
import 'package:myshopadmin/custom%20widgets/stream_single_query_builder.dart';
import 'package:myshopadmin/services/firebase_objects.dart';

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
        query: authUserCR
            .where(userMOs.memberPosition, isNull: false)
            .orderBy(userMOs.memberPosition, descending: false),
        builder: (p0, qds) {
          var um = UserModel.fromMap(qds.data());
          return StreamSingleQueryBuilder(
              query:
                  authUserCR.orderBy(userMOs.memberPosition, descending: true),
              docBuilder: (context, snapshot) {
                var umLast = UserModel.fromMap(snapshot.data());
                return GFListTile(
                  titleText: um.profileName,
                  subTitleText:
                      "Direct : ${um.directIncome * 500}\nMatrix : ${matrixIncome(um.memberPosition!, umLast.memberPosition!)}",
                  icon: Text(
                      "r${rowNumber(um.memberPosition!) + 1}p${rowPosition(um.memberPosition!)} = ${um.memberPosition}"),
                  avatar: GFAvatar(
                    backgroundImage: um.profilePhotoUrl != null
                        ? CachedNetworkImageProvider(um.profilePhotoUrl!)
                        : null,
                  ),
                );
              });
        });
  }
}

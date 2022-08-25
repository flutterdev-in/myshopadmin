import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:myshopadmin/Models/user_model.dart';
import 'package:myshopadmin/custom%20widgets/firestore_listview_builder.dart';
import 'package:myshopadmin/services/firebase_objects.dart';

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
        query: authUserCR.where(userMOs.memberPosition, isNull: true),
        builder: (p0, qds) {
          var um = UserModel.fromMap(qds.data());
          return GFListTile(
            title: Text(
              um.profileName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subTitleText: um.userEmail,
            avatar: GFAvatar(
              backgroundImage: um.profilePhotoUrl != null
                  ? CachedNetworkImageProvider(um.profilePhotoUrl!)
                  : null,
            ),
          );
        });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopadmin/Models/product_model.dart';
import 'package:myshopadmin/Screens/a_edit_product.dart';
import 'package:myshopadmin/custom%20widgets/firestore_listview_builder.dart';

import '../dart/repeatFunctions.dart';

class ListOfProducts extends StatelessWidget {
  const ListOfProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of products"),
        actions: [
          IconButton(
              onPressed: () async {
                waitMilli();
                await productMOS.addProduct();
              },
              icon: const Icon(MdiIcons.plus))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FirestoreListViewBuilder(
              query: productMOS.productsCR
                  .orderBy(productMOS.uploadTime, descending: true),
              builder: (p0, qds) {
                var pm = ProductModel.fromMap(qds.data());
                pm.docRef = qds.reference;
                return GFListTile(
                  avatar: GFAvatar(
                    backgroundImage: pm.images?.first != null
                        ? CachedNetworkImageProvider(
                            pm.images!.first!.toString(),
                          )
                        : null,
                  ),
                  title: Text(pm.name, maxLines: 2),
                  subTitleText: pm.categories.toString(),
                  icon: InkWell(
                    child: const Icon(MdiIcons.pencil),
                    onTap: () async {
                      Get.to(() => EditProductPage(pm));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

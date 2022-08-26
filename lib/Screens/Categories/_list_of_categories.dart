import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopadmin/custom%20widgets/alert_dialogue.dart';
import 'package:myshopadmin/custom%20widgets/stream_builder_widget.dart';
import 'package:myshopadmin/dart/repeatFunctions.dart';
import 'package:collection/collection.dart';
import 'package:myshopadmin/dart/rx_variables.dart';

import '../../Models/category_model.dart';
import '../../dart/colors.dart';

class ListOfCategories extends StatelessWidget {
  const ListOfCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of categories"),
      ),
      body: StreamDocBuilder(
        docRef: catMOs.categoriesDocRef(),
        docBuilder: (p0, docSnap) {
          return Column(
            children: [
              TextButton(
                  onPressed: () {
                    addCat(context, docSnap);
                  },
                  child: const Text("Add category")),
              Expanded(
                  child: ListView(
                children: catMOs
                    .listCatUptime(docSnap)
                    .mapIndexed((index, element) => catW(index, docSnap))
                    .toList(),
              )),
            ],
          );
        },
      ),
    );
  }

  Widget catW(int index, DocumentSnapshot<Map<String, dynamic>> docSnap) {
    var list = catMOs.listCatUptime(docSnap);
    var cat = list[index];

    return GFListTile(
      // padding: const EdgeInsets.all(0),
      color: Colors.brown.shade50,
      avatar: InkWell(
          child: Obx(() => GFAvatar(
                backgroundImage: cat.imageUrl != null
                    ? CachedNetworkImageProvider(cat.imageUrl!)
                    : null,
              )),
          onTap: () async {
            String? imgUrl = await catMOs.pickUploadCatImage(cat.name);
            if (imgUrl != null) {
              cat.imageUrl = imgUrl;
              cat.imageSR ??= catMOs.thisCatStorageRef(cat.name);
              list[index] = cat;
              await catMOs.updateCatDoc(list);
            }
          }),
      titleText: cat.name,
      icon: IconButton(
          onPressed: () async {
            await waitMilli();
            catMOs.removeCat(docSnap, index);
          },
          icon: const Icon(MdiIcons.delete)),
    );
  }

  void addCat(
      BuildContext context, DocumentSnapshot<Map<String, dynamic>> docSnap) {
    var image = "".obs;
    var tc = TextEditingController();

    alertDialogW(
      context,
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() => Container(
                  color: Colors.brown.shade50,
                  height: 80,
                  width: 80,
                  child: image.value.isNotEmpty
                      ? CachedNetworkImage(imageUrl: image.value)
                      : Center(
                          child: isLoading.value
                              ? const GFLoader()
                              : const Text(" Image")),
                )),
            TextButton(
                onPressed: () async {
                  if (tc.text.isNotEmpty) {
                    String? imgUrl = await catMOs.pickUploadCatImage(tc.text);
                    if (imgUrl != null) {
                      // if (image.value.isNotEmpty) {
                      //   await catMOs.thisCatStorageRef(tc.text).delete();
                      // }
                      image.value = imgUrl;
                    }
                  }
                },
                child: const Text("Pick\nimage")),
          ],
        ),
        Container(
            constraints: const BoxConstraints(
              maxHeight: 100,
            ),
            child: Obx(() => TextField(
                  controller: tc,
                  maxLines: 1,
                  minLines: 1,
                  readOnly: image.value.isEmpty ? false : true,
                  autofocus: image.value.isEmpty ? true : false,
                  decoration: const InputDecoration(
                    labelText: "Category name",
                  ),
                ))),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GFButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();

                tc.clear();
                Navigator.of(context, rootNavigator: true).pop();
                if (image.value.isNotEmpty) {
                  await catMOs.thisCatStorageRef(tc.text).delete();
                  image.value = "";
                }

                // Get.back();
              },
              color: primaryColor,
              child: const Text("Cancle"),
            ),
            GFButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if (tc.text.isNotEmpty) {
                  Get.back();
                  await waitMilli(800);
                  await catMOs.addCat(
                      docSnap,
                      CategoryModel(
                          name: tc.text,
                          imageUrl: image.value.isNotEmpty ? image.value : null,
                          uploadTime: DateTime.now(),
                          imageSR: catMOs.thisCatStorageRef(tc.text)));
                }
              },
              color: primaryColor,
              child: const Text("Add"),
            ),
          ],
        ),
      ]),
    );
  }
}

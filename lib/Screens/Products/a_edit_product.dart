import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopadmin/Models/category_model.dart';
import 'package:myshopadmin/Screens/Products/aa_edit_prices.dart';
import 'package:myshopadmin/Screens/Products/ab_edit_photos.dart';
import 'package:myshopadmin/Screens/Products/ac_edit_descriptions.dart';
import 'package:myshopadmin/custom%20widgets/alert_dialogue.dart';
import 'package:myshopadmin/custom%20widgets/stream_builder_widget.dart';
import 'package:myshopadmin/dart/repeatFunctions.dart';
import 'package:myshopadmin/dart/text_formatters.dart';
import 'package:myshopadmin/dart/useful_functions.dart';
import '../../Models/product_model.dart';
import 'package:collection/collection.dart';

class EditProductPage extends StatelessWidget {
  final ProductModel pmOld;
  const EditProductPage(this.pmOld, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit product"),
        actions: [
          IconButton(
              onPressed: () async {
                await waitMilli(500);
                await pmOld.docRef!.delete();
                await pmOld.productSR?.delete();
                await waitMilli(800);
                Get.back();
              },
              icon: const Icon(MdiIcons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: StreamDocBuilder(
            docRef: pmOld.docRef!,
            docBuilder: (context, snapshot) {
              var pm = ProductModel.fromMap(snapshot.data()!);
              pm.docRef = snapshot.reference;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text("Public visibility")),
                      GFToggle(
                          enabledText: "On",
                          disabledText: "Off",
                          onChanged: ((value) async {
                            pm.isPublic = value;
                            await pm.docRef!
                                .set(pm.toMap(), SetOptions(merge: true));
                          }),
                          value: pm.isPublic ?? false),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      maxLines: 1,
                      controller: textEditingController(pm.productID),
                      inputFormatters: [UpperCaseTextFormatter()],
                      decoration: const InputDecoration(
                        labelText: "Product ID (required)",
                      ),
                      onChanged: (value) {
                        afterDebounce(after: () async {
                          pm.productID = value;
                          pm.docRef!.set(pm.toMap(), SetOptions(merge: true));
                        });
                      },
                    ),
                  ),
                  cats(context, pm),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      maxLines: null,
                      controller: textEditingController(pm.name),
                      decoration: const InputDecoration(
                        labelText: "Product name",
                      ),
                      onChanged: (value) {
                        afterDebounce(after: () async {
                          pm.name = value;
                          await pm.docRef!
                              .set(pm.toMap(), SetOptions(merge: true));
                        });
                      },
                    ),
                  ),
                  pricesW(pm),
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () async {
                            await waitMilli();
                            Get.to(() => EditPhotos(pm));
                          },
                          child: const Text("Edit photos"))),
                  if (pm.images != null)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: pm.images!
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: CachedNetworkImage(
                                            imageUrl: e.url)),
                                  ))
                              .toList()),
                    ),
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text("Descriptions"),
                    leading: TextButton(
                        onPressed: () async {
                          await waitMilli();
                          Get.to(() => EditDescriptions(pm));
                        },
                        child: const Text("Edit")),
                    children: pm.descriptions
                            ?.map((e) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("*"),
                                      Expanded(child: Text(e.toString())),
                                    ],
                                  ),
                                ))
                            .toList() ??
                        [],
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget pricesW(ProductModel pm) {
    return Column(
      children: [
        Align(
            alignment: Alignment.topRight,
            child: TextButton(
                onPressed: () async {
                  await waitMilli();
                  Get.to(() => EditPrices(pm));
                },
                child: const Text("Edit prices"))),
        if (pm.highPrice != pm.lowPrice)
          Text("Price : from ${pm.lowPrice} to ${pm.highPrice}"),
        if (pm.listPrices != null)
          Column(
            children: pm.listPrices!
                .map((e) => Text(
                    "${e.priceName} : Price (${e.price}), MRP (${e.mrp}), Max per order (${e.maxPerOrder}), Stock available (${e.stockAvailable})"))
                .toList(),
          ),
      ],
    );
  }

  Widget cats(BuildContext context, ProductModel pm) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.brown.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Categories",
                  textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () async {
                          alertDialogW(context,
                              body: FutureBuilder<List<CategoryModel>?>(
                                  future: catMOs.listFireCatNames(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      return SizedBox(
                                        height: 350,
                                        child: SingleChildScrollView(
                                          child: Column(
                                              // shrinkWrap: true,
                                              children: snapshot.data!
                                                  .map((e) => TextButton(
                                                      onPressed: () async {
                                                        var lc = pm.categories;
                                                        lc.add(e.name);
                                                        Get.back();
                                                        await productMOS
                                                            .updateProductDoc(
                                                                pm);
                                                      },
                                                      child: Text(e.name)))
                                                  .toList()),
                                        ),
                                      );
                                    }
                                    return const Text("Loading....");
                                  }));
                        },
                        child: const Text("Add")),
                    TextButton(
                        onPressed: () {
                          alertDialogW(
                            context,
                            body: SizedBox(
                              height: 250,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: pm.categories
                                      .mapIndexed((index, e) => TextButton(
                                          onPressed: () async {
                                            var lc = pm.categories;
                                            lc.removeAt(index);
                                            Get.back();
                                            await productMOS
                                                .updateProductDoc(pm);
                                          },
                                          child: Text(e)))
                                      .toList(),
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text("Remove")),
                  ],
                )
              ],
            ),
            Wrap(
                children: pm.categories
                    .mapIndexed(
                        (index, element) => Text("${index + 1}. $element , "))
                    .toList()),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

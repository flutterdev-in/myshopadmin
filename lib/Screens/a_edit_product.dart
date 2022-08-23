import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopadmin/custom%20widgets/stream_builder_widget.dart';
import 'package:myshopadmin/dart/repeatFunctions.dart';
import 'package:myshopadmin/dart/useful_functions.dart';

import '../Models/product_model.dart';

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
                            await updateProductDoc(
                                docRef: snapshot.reference, isPublic: value);
                          }),
                          value: pm.isPublic ?? false),
                    ],
                  ),
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
                          updateProductDoc(
                              docRef: snapshot.reference, name: value);
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller:
                              textEditingController(pm.price.toString()),
                          decoration: const InputDecoration(
                            labelText: "Price",
                          ),
                          onChanged: (value) {
                            afterDebounce(after: () async {
                              updateProductDoc(
                                  docRef: snapshot.reference,
                                  price: int.tryParse(value) ?? pm.price);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: textEditingController(pm.mrp.toString()),
                          decoration: const InputDecoration(
                            labelText: "MRP",
                          ),
                          onChanged: (value) {
                            afterDebounce(after: () async {
                              updateProductDoc(
                                  docRef: snapshot.reference,
                                  mrp: int.tryParse(value) ?? pm.mrp);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller:
                              textEditingController(pm.maxPerOrder.toString()),
                          decoration: const InputDecoration(
                            labelText: "Max per order",
                          ),
                          onChanged: (value) {
                            afterDebounce(after: () async {
                              updateProductDoc(
                                  docRef: snapshot.reference,
                                  maxPerOrder:
                                      int.tryParse(value) ?? pm.maxPerOrder);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: textEditingController(
                              pm.stockAvailable.toString()),
                          decoration: const InputDecoration(
                            labelText: "Stock available",
                          ),
                          onChanged: (value) {
                            afterDebounce(after: () async {
                              updateProductDoc(
                                  docRef: snapshot.reference,
                                  stockAvailable:
                                      int.tryParse(value) ?? pm.stockAvailable);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {}, child: const Text("Edit photos"))),
               if (pm.images!=null)   SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: pm.images!
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: CachedNetworkImage(imageUrl: e)),
                                ))
                            .toList()),
                  ),
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text("Descriptions"),
                    leading:
                        TextButton(onPressed: () {}, child: const Text("Edit")),
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
}

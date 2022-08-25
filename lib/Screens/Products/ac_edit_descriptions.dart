import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopadmin/Models/product_model.dart';
import 'package:myshopadmin/dart/rx_variables.dart';
import 'package:myshopadmin/dart/useful_functions.dart';

import '../../custom widgets/stream_builder_widget.dart';
import '../../dart/repeatFunctions.dart';

class EditDescriptions extends StatelessWidget {
  final ProductModel pm;
  const EditDescriptions(this.pm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sc = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Descriptions'),
      ),
      body: StreamDocBuilder(
          docRef: pm.docRef!,
          docBuilder: (context, snapshot) {
            var pmNew = ProductModel.fromMap(snapshot.data()!);
            var listDes = pmNew.descriptions ?? [];
            return Column(
              children: [
                Container(
                  color: Colors.purple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(() => isLoading.value
                            ? const GFLoader()
                            : const Text("Add Description",
                                textScaleFactor: 1.3)),
                        IconButton(
                            onPressed: () async {
                              if (sc.hasClients) {
                                final position = sc.position.maxScrollExtent;
                                sc.jumpTo(position);
                              }

                              listDes.add((listDes.length + 1).toString());
                              await updateProductDoc(
                                  docRef: pm.docRef!, descriptions: listDes);
                              listDes.clear();
                            },
                            icon: const Icon(MdiIcons.plusBoxOutline)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                      controller: sc,
                      children: pmNew.descriptions?.map((e) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextField(
                                    maxLines: null,
                                    controller:
                                        textEditingController(e.toString()),
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      labelText:
                                          "${pmNew.descriptions!.indexOf(e) + 1} . Description",
                                    ),
                                    onChanged: (value) async {
                                      afterDebounce(after: () async {
                                        listDes[listDes.indexOf(e)] = value;
                                        await updateProductDoc(
                                            docRef: pm.docRef!,
                                            descriptions: listDes);
                                      });
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: TextButton(
                                      onPressed: () async {
                                        await waitMilli();

                                        listDes.remove(e);
                                        await updateProductDoc(
                                            docRef: pm.docRef!,
                                            descriptions: listDes);
                                      },
                                      child: const Text("Remove")),
                                ),
                              ],
                            );
                          }).toList() ??
                          []),
                ),
                Container(color: Colors.purple.shade50, height: 50),
              ],
            );
          }),
    );
  }
}

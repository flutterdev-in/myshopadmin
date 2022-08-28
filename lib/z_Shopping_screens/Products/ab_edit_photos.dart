import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopadmin/Models/product_model.dart';
import 'package:myshopadmin/dart/repeatFunctions.dart';
import 'package:myshopadmin/dart/rx_variables.dart';

import '../../custom widgets/stream_builder_widget.dart';

class EditPhotos extends StatelessWidget {
  final ProductModel pm;
  const EditPhotos(this.pm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit photos'),
      ),
      body: Column(
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
                      : const Text("Add photo", textScaleFactor: 1.3)),
                  IconButton(
                      onPressed: () async {
                        await productMOS.productImageUpload(
                            ImageSource.gallery, pm.docRef!);
                      },
                      icon: const Icon(MdiIcons.image)),
                  IconButton(
                      onPressed: () async {
                        await productMOS.productImageUpload(
                            ImageSource.camera, pm.docRef!);
                      },
                      icon: const Icon(MdiIcons.camera)),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: StreamDocBuilder(
                stream: pm.docRef!,
                builder: (context, snapshot) {
                  var pmNew = ProductModel.fromMap(snapshot.data()!);
                  return Wrap(
                      children: pmNew.images?.map((e) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                child: Card(
                                  elevation: 10,
                                  shadowColor: Colors.brown,
                                  child: SizedBox(
                                      height: 150,
                                      child:
                                          CachedNetworkImage(imageUrl: e.url)),
                                ),
                                onLongPress: () {
                                  Get.bottomSheet(Container(
                                      color: Colors.white,
                                      height: 150,
                                      child: Center(
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              await waitMilli();
                                              var listImages =
                                                  pmNew.images ?? [];
                                              listImages.remove(e);
                                              Get.back();
                                              await updateProductDoc(
                                                  docRef: pm.docRef!,
                                                  images: listImages);
                                              await e.sr?.delete();
                                            },
                                            child: const Text(
                                                "Delete this image")),
                                      )));
                                },
                              ),
                            );
                          }).toList() ??
                          []);
                }),
          ),
        ],
      ),
    );
  }
}

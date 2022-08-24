import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myshopadmin/Screens/a_edit_product.dart';

import '../dart/const_global_objects.dart';
import '../dart/rx_variables.dart';
import '../services/firebase_objects.dart';

class ProductModel {
  String name;
  List<ImageModel>? images;
  DateTime uploadTime;
  List categories;
  num mrp;
  num? price;
  List? descriptions;
  int stockAvailable;
  int maxPerOrder;
  bool? isPublic;
  int? productNumber;
  Reference? productSR;

  DocumentReference<Map<String, dynamic>>? docRef;

  ProductModel({
    required this.name,
    required this.images,
    required this.uploadTime,
    required this.categories,
    required this.mrp,
    required this.price,
    required this.descriptions,
    required this.maxPerOrder,
    required this.stockAvailable,
    required this.isPublic,
    required this.productNumber,
    required this.productSR,
  });

  Map<String, dynamic> toMap() {
    return {
      productMOS.name: name,
      productMOS.images: images?.map((e) => e.toMap()).toList(),
      productMOS.uploadTime: Timestamp.fromDate(uploadTime),
      productMOS.categories: categories,
      productMOS.mrp: mrp,
      productMOS.price: price,
      productMOS.descriptions: descriptions,
      productMOS.maxPerOrder: maxPerOrder,
      productMOS.stockAvailable: stockAvailable,
      productMOS.isPublic: isPublic,
      productMOS.productNumber: productNumber,
      "productSR": productSR,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> productMap) {
    var listImages = productMap[productMOS.images] as List;
    return ProductModel(
      name: productMap[productMOS.name] ?? "",
      images: listImages.map((e) => ImageModel.fromMap(e)).toList(),
      uploadTime: productMap[productMOS.uploadTime]?.toDate(),
      categories: productMap[productMOS.categories],
      mrp: productMap[productMOS.mrp],
      price: productMap[productMOS.price],
      descriptions: productMap[productMOS.descriptions],
      maxPerOrder: productMap[productMOS.maxPerOrder],
      stockAvailable: productMap[productMOS.stockAvailable],
      isPublic: productMap[productMOS.isPublic],
      productNumber: productMap[productMOS.productNumber],
      productSR: productMap["productSR"] != null
          ? storageRef.child(productMap["productSR"])
          : null,
    );
  }
}

ProductModelObjects productMOS = ProductModelObjects();

class ProductModelObjects {
  final name = "name";
  final price = "price";
  final mrp = "mrp";
  final categories = "categories";
  final images = "images";
  final descriptions = "descriptions";
  final uploadTime = "uploadTime";
  final maxPerOrder = "maxPerOrder";
  final stockAvailable = "stockAvailable";
  final isPublic = "isPublic";
  final productNumber = "productNumber";
  final productsCR = FirebaseFirestore.instance.collection("products");

  Reference productSR(DocumentReference<Map<String, dynamic>> productDR) {
    return storageRef.child("products").child(productDR.id);
  }

  Future<void> addProduct() async {
    var pm = ProductModel(
        name: "",
        images: null,
        uploadTime: DateTime.now(),
        categories: [],
        mrp: 0,
        price: 0,
        descriptions: null,
        maxPerOrder: 0,
        stockAvailable: 0,
        productNumber: null,
        productSR: null,
        isPublic: false);
    await productsCR
        .orderBy(productNumber, descending: true)
        .limit(1)
        .get()
        .then((qs) {
      if (qs.docs.isNotEmpty) {
        var pmLast = ProductModel.fromMap(qs.docs.first.data());
        pm.productNumber = (pmLast.productNumber ?? 0 + 1);
      }
    });

    await productsCR.add(pm.toMap()).then((dr) {
      pm.docRef = dr;
      Get.to(() => EditProductPage(pm));
    });
  }

  //
  //
  Future<void> productImageUpload(ImageSource source,
      DocumentReference<Map<String, dynamic>> productDR) async {
    await imagePicker.pickImage(source: source).then((photo) async {
      if (photo != null) {
        isLoading.value = true;
        // isLoading.value = true;
        await FlutterNativeImage.compressImage(
          photo.path,
          percentage: 85,
          quality: 85,
        ).then((compressedFile) async {
          final name = DateFormat("dd_MMM_HH_mm").format(DateTime.now());
          final photoSR = productMOS.productSR(productDR).child("$name.jpg");
          await photoSR.putFile(compressedFile).then((ts) async {
            await ts.ref.getDownloadURL().then((url) async {
              await productDR.update({
                images: FieldValue.arrayUnion(
                    [ImageModel(url: url, sr: photoSR).toMap()])
              });
            });
          });
        });
      }
      isLoading.value = false;
    });
  }
}

Future<void> updateProductDoc({
  required DocumentReference<Map<String, dynamic>> docRef,
  String? name,
  List<ImageModel>? images,
  DateTime? uploadTime,
  List? categories,
  num? mrp,
  num? price,
  List? descriptions,
  int? stockAvailable,
  int? maxPerOrder,
  bool? isPublic,
  int? productNumber,
}) async {
  Map<String, dynamic> map = {
    productMOS.name: name,
    productMOS.images: images?.map((e) => e.toMap()).toList(),
    productMOS.uploadTime: uploadTime,
    productMOS.categories: categories,
    productMOS.mrp: mrp,
    productMOS.price: price,
    productMOS.descriptions: descriptions,
    productMOS.maxPerOrder: maxPerOrder,
    productMOS.stockAvailable: stockAvailable,
    productMOS.isPublic: isPublic,
    productMOS.productNumber: productNumber,
  };

  Map<String, dynamic> updatedMap = {};
  map.forEach((key, value) {
    if (value != null) {
      updatedMap.addAll({key: value});
    }
  });

  await docRef.update(updatedMap);
}

class ImageModel {
  String url;
  Reference? sr;
  ImageModel({
    required this.url,
    required this.sr,
  });

  Map<String, dynamic> toMap() {
    return {
      "url": url,
      "sr": sr?.fullPath,
    };
  }

  factory ImageModel.fromMap(var image) {
    if (image is Map) {
      return ImageModel(
        url: image["url"] ?? "",
        sr: image["sr"] != null ? storageRef.child(image["sr"]) : null,
      );
    } else {
      return ImageModel(
        url: image ?? "",
        sr: null,
      );
    }
  }
}

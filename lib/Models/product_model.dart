import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myshopadmin/Screens/Products/a_edit_product.dart';

import '../dart/const_global_objects.dart';
import '../dart/rx_variables.dart';
import '../services/firebase_objects.dart';
import 'prices_model.dart';

class ProductModel {
  String? productID;
  String name;

  List<ImageModel>? images;
  DateTime uploadTime;
  List<String> categories;
  List<PricesModel>? listPrices;
  num highPrice;
  num lowPrice;
  List? descriptions;
  String? priceType;
  bool? isPublic;

  int? productNumber;
  Reference? productSR;

  DocumentReference<Map<String, dynamic>>? docRef;

  ProductModel({
    required this.name,
    required this.images,
    required this.uploadTime,
    required this.categories,
    required this.highPrice,
    required this.lowPrice,
    required this.listPrices,
    required this.descriptions,
    required this.isPublic,
    required this.productID,
    required this.productSR,
    required this.priceType,
    required this.productNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      productMOS.name: name,
      productMOS.images: images?.map((e) => e.toMap()).toList(),
      productMOS.uploadTime: Timestamp.fromDate(uploadTime),
      productMOS.lowPrice:
          listPrices != null ? pricesMOs.minMaxPrice(listPrices!)[1] : lowPrice,
      productMOS.highPrice: listPrices != null
          ? pricesMOs.minMaxPrice(listPrices!)[1]
          : highPrice,
      productMOS.listPrices: listPrices?.map((e) => e.toMap()).toList(),
      productMOS.categories: categories,
      productMOS.descriptions: descriptions,
      productMOS.isPublic: isPublic,
      productMOS.productID: productID,
      productMOS.priceType: priceType,
      productMOS.productSR: productSR?.fullPath,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> productMap) {
    var listImages = productMap[productMOS.images] as List?;
    var listPrcs0 = productMap[productMOS.listPrices] as List?;
    var listPrcs = listPrcs0?.map((e) => PricesModel.fromMap(e)).toList();
    var listCat0 = productMap[productMOS.categories] as List?;
    var listCat = listCat0?.map(((e) => e.toString())).toList();
    return ProductModel(
      name: productMap[productMOS.name] ?? "",
      images: listImages?.map((e) => ImageModel.fromMap(e)).toList(),
      listPrices: listPrcs,
      uploadTime: productMap[productMOS.uploadTime]?.toDate(),
      lowPrice: listPrcs != null
          ? pricesMOs.minMaxPrice(listPrcs)[0]
          : productMap[productMOS.highPrice] ?? 0,
      highPrice: listPrcs != null
          ? pricesMOs.minMaxPrice(listPrcs)[1]
          : productMap[productMOS.highPrice] ?? 0,
      categories: listCat ?? [],
      descriptions: productMap[productMOS.descriptions],
      isPublic: productMap[productMOS.isPublic],
      priceType: productMap[productMOS.priceType],
      productNumber: productMap[productMOS.productNumber],
      productID: productMap[productMOS.productID],
      productSR: productMap[productMOS.productSR] != null
          ? storageRef.child(productMap[productMOS.productSR])
          : null,
    );
  }
}

ProductModelObjects productMOS = ProductModelObjects();

class ProductModelObjects {
  final name = "name";
  final highPrice = "highPrice";
  final lowPrice = "lowPrice";
  final categories = "categories";
  final images = "images";
  final descriptions = "descriptions";
  final uploadTime = "uploadTime";
  final listPrices = "listPrices";
  final isPublic = "isPublic";
  final productID = "productID";
  final productNumber = "productNumber";
  final productSR = "productSR";
  final priceType = "priceType";
  final productsCR = FirebaseFirestore.instance.collection("products");

  Reference productSRf(DocumentReference<Map<String, dynamic>> productDR) {
    return storageRef.child("products").child(productDR.id);
  }

  Future<void> updateProductDoc(ProductModel pm) async {
    var dr = pm.docRef!;
    await dr.set(pm.toMap(), SetOptions(merge: true));
  }

  Future<void> addProduct() async {
    var pm = ProductModel(
        name: "",
        images: null,
        uploadTime: DateTime.now(),
        categories: [],
        descriptions: null,
        productID: null,
        listPrices: null,
        highPrice: 0,
        lowPrice: 0,
        priceType: null,
        productSR: null,
        productNumber: null,
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

    await productsCR.add(pm.toMap()).then((dr) async {
      pm.docRef = dr;
      pm.productSR = productSRf(dr);
      await dr.set(pm.toMap(), SetOptions(merge: true));
     
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
          final photoSR = productMOS.productSRf(productDR).child("$name.jpg");
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
    productMOS.descriptions: descriptions,
    productMOS.isPublic: isPublic,
    productMOS.productID: productNumber,
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

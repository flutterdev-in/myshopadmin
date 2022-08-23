import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myshopadmin/Screens/a_edit_product.dart';
import 'package:easy_debounce/easy_debounce.dart';
class ProductModel {
  String name;
  List? images;
  DateTime uploadTime;
  List categories;
  num mrp;
  num? price;
  List? descriptions;
  int stockAvailable;
  int maxPerOrder;
  bool? isPublic;
  int? productNumber;
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
  });

  Map<String, dynamic> toMap() {
    return {
      productMOS.name: name,
      productMOS.images: images,
      productMOS.uploadTime: Timestamp.fromDate(uploadTime),
      productMOS.categories: categories,
      productMOS.mrp: mrp,
      productMOS.price: price,
      productMOS.descriptions: descriptions,
      productMOS.maxPerOrder: maxPerOrder,
      productMOS.stockAvailable: stockAvailable,
      productMOS.isPublic: isPublic,
      productMOS.productNumber: productNumber,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> productMap) {
    return ProductModel(
      name: productMap[productMOS.name] ?? "",
      images: productMap[productMOS.images],
      uploadTime: productMap[productMOS.uploadTime]?.toDate(),
      categories: productMap[productMOS.categories],
      mrp: productMap[productMOS.mrp],
      price: productMap[productMOS.price],
      descriptions: productMap[productMOS.descriptions],
      maxPerOrder: productMap[productMOS.maxPerOrder],
      stockAvailable: productMap[productMOS.stockAvailable],
      isPublic: productMap[productMOS.isPublic],
      productNumber: productMap[productMOS.productNumber],
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

}

  Future<void> updateProductDoc({
    required DocumentReference<Map<String, dynamic>> docRef,
    String? name,
    List? images,
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
      productMOS.images: images,
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

 
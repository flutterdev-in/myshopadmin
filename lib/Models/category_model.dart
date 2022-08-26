import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myshopadmin/services/fire_admin.dart';

import '../dart/const_global_objects.dart';
import '../dart/rx_variables.dart';
import '../services/firebase_objects.dart';

class CategoryModel {
  String name;
  String? imageUrl;
  DateTime uploadTime;
  Reference? imageSR;

  CategoryModel({
    required this.name,
    required this.imageUrl,
    required this.uploadTime,
    required this.imageSR,
  });

  Map<String, dynamic> toMap() {
    return {
      catMOs.name: name,
      catMOs.imageUrl: imageUrl,
      catMOs.uploadTime: Timestamp.fromDate(uploadTime),
      catMOs.imageSR: imageSR?.fullPath,
    };
  }

  factory CategoryModel.fromMap(Map catMap) {
    return CategoryModel(
      name: catMap[catMOs.name],
      imageUrl: catMap[catMOs.imageUrl],
      uploadTime: catMap[catMOs.uploadTime]?.toDate(),
      imageSR: catMap[catMOs.imageSR] != null
          ? storageRef.child(catMap[catMOs.imageSR])
          : null,
    );
  }
}

CategoriesModelObjects catMOs = CategoriesModelObjects();

class CategoriesModelObjects {
  final name = "name";
  final imageUrl = "imageUrl";
  final uploadTime = "uploadTime";
  final listCat = "listCat";
  final imageSR = "imageSR";

  final categories = "categories";
  DocumentReference<Map<String, dynamic>> categoriesDocRef() {
    return fa.adminCR.doc(categories);
  }

  Reference thisCatStorageRef(String catName) {
    return storageRef.child(categories).child("$catName.jpg");
  }

  Future<List<CategoryModel>?> listFireCatNames() async {
    return await categoriesDocRef().get().then((value) => listCatNames(value));
  }

  List<CategoryModel> listCatUptime(
      DocumentSnapshot<Map<String, dynamic>> docSnap) {
    var list0 = docSnap.data()?[listCat] as List;
    var list = list0.map((e) => CategoryModel.fromMap(e)).toList();
    list.sort((p1, p2) {
      return Comparable.compare(p2.uploadTime, p1.uploadTime);
    });
    return list;
  }

  List<CategoryModel> listCatNames(
      DocumentSnapshot<Map<String, dynamic>>? docSnap) {
    var list0 = docSnap!.data()?[listCat] as List;
    var list = list0.map((e) => CategoryModel.fromMap(e)).toList();
    list.sort((p1, p2) {
      return Comparable.compare(p1.name, p2.name);
    });
    return list;
  }

  Future<void> addCat(
      DocumentSnapshot<Map<String, dynamic>> docSnap, CategoryModel cm) async {
    var list = listCatUptime(docSnap);
    list.add(cm);
    list.sort((p1, p2) {
      return Comparable.compare(p2.uploadTime, p1.uploadTime);
    });
    await docSnap.reference.set({listCat: list.map((e) => e.toMap()).toList()},
        SetOptions(merge: true));
  }

  Future<void> removeCat(
      DocumentSnapshot<Map<String, dynamic>> docSnap, int catIndex) async {
    var list = listCatUptime(docSnap);
    await list[catIndex].imageSR?.delete();
    list.removeAt(catIndex);

    await updateCatDoc(list);
  }

  Future<String?> pickUploadCatImage(String name) async {
    String? image;
    await imagePicker
        .pickImage(source: ImageSource.gallery)
        .then((photo) async {
      if (photo != null) {
        isLoading.value = true;
        // isLoading.value = true;
        await FlutterNativeImage.compressImage(
          photo.path,
          percentage: 85,
          quality: 85,
        ).then((compressedFile) async {
          final photoSR = thisCatStorageRef(name);
          await photoSR.putFile(compressedFile).then((ts) async {
            await ts.ref.getDownloadURL().then((url) async {
              image = url;
            });
          });
        });
      }
      isLoading.value = false;
    });
    return image;
  }

  //
  Future<void> updateCatDoc(List<CategoryModel> listCats) async {
    await categoriesDocRef().set(
        {listCat: listCats.map((e) => e.toMap()).toList()},
        SetOptions(merge: true));
  }
}

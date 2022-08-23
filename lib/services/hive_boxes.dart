import 'package:hive_flutter/hive_flutter.dart';

BoxNames boxNames = BoxNames();

class BoxNames {
  final userBox = "userBox";
  final services = "services";
}

final userBox = Hive.box(boxNames.userBox);
final servicesBox = Hive.box(boxNames.services);

//
String? userBoxUID() {
  return userBox.get(boxStrings.userUID);
}

//
BoxStrings boxStrings = BoxStrings();

class BoxStrings {
  final userUID = "userUID";
  final fcmToken = "fcmToken";

}

//


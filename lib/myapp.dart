import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myshopadmin/dart/colors.dart';
import 'app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: primaryColor),
        primaryColor: Colors.deepPurple.shade800,
        primaryColorLight: Colors.deepPurple.shade800,
        // textTheme: Theme.of(context).textTheme.apply(),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      title: 'My Shop AU',
      initialRoute: "/",
      getPages: appRoutes,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void bottomBarLogin() {
  Get.bottomSheet(
    SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Please login to proceed"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () async {
                    await Future.delayed(const Duration(microseconds: 500));

                    Get.back();
                   
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(MdiIcons.google),
                      SizedBox(width: 8),
                      Text("Login with Google"),
                    ],
                  )),
            ),
          ],
        ),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

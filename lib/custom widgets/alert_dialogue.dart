import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../dart/colors.dart';

alertDialogW(
  BuildContext context, {
  EdgeInsets insetPadding = const EdgeInsets.all(10),
  EdgeInsetsGeometry contentPadding =
      const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 24.0),
  bool scrollable = true,
  MainAxisAlignment? actionsAlignment = MainAxisAlignment.start,
  required Widget body,
  bool barrierDismissible = false,
}) {
  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) => AlertDialog(
      insetPadding: insetPadding,
      contentPadding: contentPadding,
      scrollable: true,
      actionsAlignment: actionsAlignment,
      content: body,
    ),
  );
}

textFieldAlertW(BuildContext context,
    {required String? text,
    required void Function(String?) onPressedConfirm,
    Widget? headerW,
    Widget? footerW,
    String? hintText,
    int? maxLines ,
    String? lableText,
    double teextFieldMaxHeight = 100,
    String confirmText = "Update"}) {
  var tc = TextEditingController();
  tc.text = text ?? "";
  alertDialogW(context,
      body: Column(
        children: [
          if (headerW != null) headerW,
          Container(
              constraints: BoxConstraints(
                maxHeight: teextFieldMaxHeight,
              ),
              child: TextField(
                controller: tc,
                maxLines: maxLines,
                minLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: hintText,
                  labelText: lableText,
                ),
              )),
          if (footerW != null) footerW,
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GFButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  tc.clear();
                  Navigator.of(context, rootNavigator: true).pop();
                  // Get.back();
                },
                color: primaryColor,
                child: const Text("Cancle"),
              ),
              GFButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (tc.text.isNotEmpty) {
                    onPressedConfirm(tc.text);
                  }
                },
                color: primaryColor,
                child: Text(confirmText),
              )
            ],
          ),
        ],
      ));
}

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/widgets.dart';

void afterDebounce({
  int seconds = 1,
  required Future<void> Function() after,
}) async {
  EasyDebounce.debounce('d', const Duration(seconds: 2), after);
}

TextEditingController textEditingController(String? text) {
  var tc = TextEditingController();
  tc.text = text ?? "";
  // tc.selection =
  //     TextSelection.fromPosition(TextPosition(offset: tc.text.length));
  return tc;
}

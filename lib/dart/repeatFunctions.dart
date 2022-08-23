Future<void> waitMilli([int milli = 500]) async {
  await Future.delayed(Duration(milliseconds: milli));
}

import 'package:get/get.dart';
import 'package:myshopadmin/auth_gate.dart';

final appRoutes = [
  GetPage(
    name: "/",
    page: () {
      return const AuthGate();
    },
  ),
  
];

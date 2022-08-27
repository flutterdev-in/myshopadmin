import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopadmin/z_Prime_screens/_prime_home_screen.dart';

import 'package:myshopadmin/services/firebase_objects.dart';
import 'package:myshopadmin/z_Shopping_screens/_shopping_home_screen.dart';

import 'dart/colors.dart';
import 'services/firebase_objects.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabC;
  @override
  void initState() {
    super.initState();
    tabC = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: Get.width - 50,
        child: drawerItems(),
      ),
      appBar: AppBar(
          title: const Text("Admin Home Page"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(36.0),
            child: TabBar(
              controller: tabC,
              indicatorColor: Colors.white70,
              tabs: const [
                SizedBox(height: 30, child: Center(child: Text("Prime"))),
                SizedBox(height: 30, child: Center(child: Text("Shopping"))),
              ],
              indicatorWeight: 2.5,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: TabBarView(
          controller: tabC,
          children: const [
            PrimeHomeScreen(),
            ShoppingHomeScreen(),
          ],
        ),
      ),
    );
  }

  Widget drawerItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: primaryColor,
          height: 90,
          width: double.maxFinite,
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "\nMENU",
                textScaleFactor: 1.2,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    fireLogOut();
                  },
                  child: Row(
                    children: const [
                      Icon(MdiIcons.account),
                      SizedBox(width: 10),
                      Text("Logout"),
                    ],
                  )),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(MdiIcons.cart),
                      SizedBox(width: 10),
                      Text("My Shop"),
                    ],
                  )),
              const SizedBox(height: 10),
              const Text("Updated 28 Aug, 12:13am"),
            ],
          ),
        ),
      ],
    );
  }
}

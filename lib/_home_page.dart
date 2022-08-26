import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopadmin/Screens/Categories/_list_of_categories.dart';
import 'package:myshopadmin/Screens/Products/_list_of_products.dart';
import 'package:myshopadmin/Screens/prime_members.dart';
import 'package:myshopadmin/services/firebase_objects.dart';

import 'Screens/non_prime_members.dart';
import 'dart/colors.dart';
import 'dart/repeatFunctions.dart';
import 'services/firebase_objects.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Home Page"),
      ),
      drawer: Drawer(
        width: Get.width - 50,
        child: drawerItems(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GFListTile(
            titleText: "Prime members",
            avatar: const Icon(MdiIcons.accountGroup),
            onTap: () async {
              waitMilli();
              Get.to(() => const PrmeMembersPage());
            },
          ),
          GFListTile(
            titleText: "Non prime Gmail members",
            avatar: const Icon(MdiIcons.account),
            onTap: () async {
              await waitMilli();
              Get.to(() => const NonPrmeMembersPage());
            },
          ),
          GFListTile(
            titleText: "List of products",
            avatar: const Icon(MdiIcons.formatListText),
            onTap: () async {
              waitMilli();
              Get.to(() => const ListOfProducts());
            },
          ),
          GFListTile(
            titleText: "List of categories",
            avatar: const Icon(MdiIcons.clipboardListOutline),
            onTap: () async {
              waitMilli();
              Get.to(() => const ListOfCategories());
            },
          ),
        ],
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
            ],
          ),
        ),
      ],
    );
  }
}

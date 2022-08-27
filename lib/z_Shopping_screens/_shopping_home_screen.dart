import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Screens/Policies/_list_policies.dart';
import '../dart/repeatFunctions.dart';
import 'Categories/_list_of_categories.dart';
import 'Products/_list_of_products.dart';

class ShoppingHomeScreen extends StatelessWidget {
  const ShoppingHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        GFListTile(
          titleText: "Policies",
          avatar: const Icon(MdiIcons.policeBadge),
          onTap: () async {
            waitMilli();
            Get.to(() => const ListPolicies());
          },
        ),
      ],
    );
  }
}

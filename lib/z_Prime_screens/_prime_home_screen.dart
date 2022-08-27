import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Screens/Policies/_list_policies.dart';
import '../dart/repeatFunctions.dart';
import 'non_prime_members.dart';
import 'prime_members.dart';

class PrimeHomeScreen extends StatelessWidget {
  const PrimeHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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

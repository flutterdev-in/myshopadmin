import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopadmin/custom%20widgets/firestore_listview_builder.dart';

import '../../Models/policy_model.dart';
import '../../dart/repeatFunctions.dart';
import 'edit_main_policy.dart';

class ListPolicies extends StatelessWidget {
  final bool isPrime;
  const ListPolicies(this.isPrime, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${isPrime ? 'Prime' : 'Shopping'} Policies"),
        actions: [
          IconButton(
              onPressed: () async {
                waitMilli();
                await policyMOs.addPolicy(isPrime);
              },
              icon: const Icon(MdiIcons.plus))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FirestoreListViewBuilder(
              query: policyMOs
                  .policiesCR()
                  .where(policyMOs.isPrimePolicy, isEqualTo: isPrime),
              builder: ( qds) {
                var pm = PolicyModel.fromMap(qds.data());
                pm.docRef = qds.reference;
                return GFListTile(
                  title: Text(
                    pm.heading,
                    maxLines: 2,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  icon: InkWell(
                    child: const Icon(MdiIcons.pencil),
                    onTap: () async {
                      Get.to(() => EditMainPolicy(pm));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

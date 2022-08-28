import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../Models/policy_model.dart';
import '../../custom widgets/stream_builder_widget.dart';
import '../../dart/useful_functions.dart';
import 'package:collection/collection.dart';

class EditMainPolicy extends StatelessWidget {
  final PolicyModel pmOld;
  const EditMainPolicy(this.pmOld, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      body: StreamDocBuilder(
          stream: pmOld.docRef!,
          builder: (context, snapshot) {
            var pm = PolicyModel.fromMap(snapshot.data()!);
            pm.docRef = snapshot.reference;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () async {
                          pm.docRef!.delete();
                          Get.back();
                        },
                        child: const Text("Delete this policy")),
                    const Text(" | "),
                    TextButton(
                        onPressed: () async {
                          var l = pm.listPoliy ?? [];
                          l.add(Policy(
                              name: "Dummy sub policy", description: ""));
                          pm.listPoliy = l;
                          pm.docRef!.set(pm.toMap(), SetOptions(merge: true));
                        },
                        child: const Text("Add sub policy")),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: TextField(
                    maxLines: null,
                    controller: textEditingController(pm.heading),
                    decoration: const InputDecoration(
                      labelText: "Policy Heading",
                    ),
                    onChanged: (value) {
                      afterDebounce(after: () async {
                        pm.heading = value;
                        await pm.docRef!
                            .set(pm.toMap(), SetOptions(merge: true));
                      });
                    },
                  ),
                ),
                if (pm.listPoliy != null)
                  Expanded(
                    child: ListView(
                      children: pm.listPoliy!
                          .mapIndexed((index, policy) => GFListTile(
                                title: policy.name.isNotEmpty
                                    ? Text(
                                        policy.name,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    : null,
                                subTitle: Text(policy.description, maxLines: 2),
                                icon: InkWell(
                                  child: const Icon(MdiIcons.pencil),
                                  onTap: () async {
                                    Get.to(() => EditSubPolicy(index, pm));
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  )
              ],
            );
          }),
    );
  }
}

class EditSubPolicy extends StatelessWidget {
  final PolicyModel pmOld;
  int subPolicyIndex;
  EditSubPolicy(this.subPolicyIndex, this.pmOld, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () async {
                Get.back();
                var l = pmOld.listPoliy ?? [];
                l.removeAt(subPolicyIndex);
                if (subPolicyIndex > 0) {
                  subPolicyIndex--;
                }

                pmOld.listPoliy = l;

                pmOld.docRef!.set(pmOld.toMap(), SetOptions(merge: true));
              },
              child: const Text("Delete this sub policy")),
          SingleChildScrollView(
            child: StreamDocBuilder(
                stream: pmOld.docRef!,
                builder: (context, snapshot) {
                  var pm = PolicyModel.fromMap(snapshot.data()!);
                  pm.docRef = snapshot.reference;

                  var pl = pm.listPoliy![subPolicyIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: TextField(
                          maxLines: null,
                          controller: textEditingController(pl.name),
                          decoration: const InputDecoration(
                            labelText: "Sub Policy name",
                          ),
                          onChanged: (value) {
                            afterDebounce(after: () async {
                              pl.name = value;
                              var l = pm.listPoliy!;
                              l[subPolicyIndex] = pl;
                              pm.listPoliy = l;
                              await pm.docRef!
                                  .set(pm.toMap(), SetOptions(merge: true));
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: TextField(
                          maxLines: null,
                          controller: textEditingController(pl.description),
                          decoration: const InputDecoration(
                            labelText: "Sub Policy Description",
                          ),
                          onChanged: (value) {
                            afterDebounce(after: () async {
                              pl.description = value;
                              var l = pm.listPoliy!;
                              l[subPolicyIndex] = pl;
                              pm.listPoliy = l;
                              await pm.docRef!
                                  .set(pm.toMap(), SetOptions(merge: true));
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

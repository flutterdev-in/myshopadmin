import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopadmin/Models/prime_member_model.dart';
import 'package:myshopadmin/custom%20widgets/stream_single_query_builder.dart';
import 'package:myshopadmin/dart/useful_functions.dart';

import '../custom widgets/stream_builder_widget.dart';
import '../dart/repeatFunctions.dart';
import '../matrix/positions.dart';

class MemberDashboard extends StatelessWidget {
  final PrimeMemberModel pmmOld;
  final bool isPrimeMember;
  final bool wantAppbar;
  const MemberDashboard(this.pmmOld, this.isPrimeMember, this.wantAppbar,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wantAppbar
          ? AppBar(
              title: Text(pmmOld.name!),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!isPrimeMember) streamWidget(),
            GFListTile(
              avatar: GFAvatar(
                backgroundImage: pmmOld.profilePhotoUrl != null
                    ? CachedNetworkImageProvider(pmmOld.profilePhotoUrl!)
                    : null,
              ),
              titleText: pmmOld.name,
              icon: isPrimeMember
                  ? Text(
                      "r${rowNumber(pmmOld.memberPosition ?? 0) + 1}p${rowPosition(pmmOld.memberPosition ?? 0)} = ${pmmOld.memberPosition}")
                  : null,
            ),
            GFListTile(
              titleText: "Member ID",
              subTitleText: pmmOld.memberID,
            ),
            GFListTile(
              titleText: "Phone number",
              subTitleText: pmmOld.phoneNumber,
            ),
            GFListTile(
              titleText: "Email id",
              subTitleText: pmmOld.email,
            ),
            GFListTile(
              titleText: "UserName",
              subTitleText: pmmOld.userName,
            ),
            GFListTile(
              titleText: "Password",
              subTitleText: pmmOld.userPassword,
            ),
            GFListTile(
              titleText: "Interested In",
              subTitleText: pmmOld.interestedIn,
            ),
            StreamSingleQueryBuilder(
                noResultsW: const Text("Referrar = Company"),
                stream: primeMOs
                    .primeMembersCR()
                    .where(primeMOs.memberID, isEqualTo: pmmOld.refMemberId),
                builder: (context, snapshot) {
                  var pmmR = PrimeMemberModel.fromMap(snapshot.data());
                  return GFListTile(
                    avatar: GFAvatar(
                      backgroundImage: pmmR.profilePhotoUrl != null
                          ? CachedNetworkImageProvider(pmmR.profilePhotoUrl!)
                          : null,
                    ),
                    titleText: "Referrar (${pmmOld.refMemberId})",
                    subTitleText: "${pmmR.name}\n${pmmR.phoneNumber}",
                    icon: Text(
                        "r${rowNumber(pmmR.memberPosition ?? 0) + 1}p${rowPosition(pmmR.memberPosition ?? 0)} = ${pmmR.memberPosition}"),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget streamWidget() {
    return StreamDocBuilder(
        stream: pmmOld.docRef!,
        builder: (context, snapshot) {
          var pmm2 = PrimeMemberModel.fromMap(snapshot.data()!);
          pmm2.docRef = snapshot.reference;
          return Column(
            children: [
              GFListTile(
                title: snapshot.exists
                    ? const Text("Delete this member")
                    : const Text("Member deleted"),
                icon: TextButton(
                    onPressed: () async {
                      await waitMilli();
                      if (snapshot.exists && pmm2.memberPosition == null) {
                        await snapshot.reference.delete();
                      }
                    },
                    child: pmm2.memberPosition == null
                        ? const Text("Delete")
                        : const Text("")),
              ),
              GFListTile(
                title: pmm2.memberPosition == null
                    ? const Text("Is member paid")
                    : Text(
                        "Member marked as Paid\nHis Prime position is ${pmm2.memberPosition}"),
                icon: TextButton(
                    onPressed: () async {
                      await waitMilli();
                      pmm2.isPaid = true;
                      await addPrimePosition(pmm2);
                    },
                    child: pmm2.memberPosition == null
                        ? const Text("Paid")
                        : const Icon(
                            MdiIcons.checkCircle,
                            color: Colors.green,
                          )),
              ),
              GFListTile(
                title: pmm2.memberPosition == null
                    ? const Text("Replace with prime member")
                    : const Text(
                        "Member has been replaced\nRelevent incomes has been adjusted"),
                icon: TextButton(
                    onPressed: () async {
                      var primePos = 0.obs;
                      var isSelected = false.obs;
                      await waitMilli();
                      // pmm2.isPaid = true;
                      // await addPrimePosition(pmm2);
                      Get.bottomSheet(Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextField(
                                maxLength: 3,
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Enter a prime position",
                                ),
                                onChanged: (value) {
                                  isSelected.value = false;
                                  afterDebounce(after: () async {
                                    primePos.value = int.tryParse(value) ?? 0;
                                  });
                                },
                              ),
                              Obx(() => StreamSingleQueryBuilder(
                                  stream: primeMOs.primeMembersCR().where(
                                      primeMOs.memberPosition,
                                      isEqualTo: primePos.value),
                                  builder: (context, snapshot) {
                                    var pmmToBeReplaced =
                                        PrimeMemberModel.fromMap(
                                            snapshot.data());
                                    pmmToBeReplaced.docRef = snapshot.reference;
                                    return Obx(() => Column(
                                          children: [
                                            const Text(
                                                "Select and confirm to replace\nIt cannot be undo"),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            GFListTile(
                                              color: isSelected.value
                                                  ? Colors.red.shade100
                                                  : null,
                                              title: Text(
                                                pmmToBeReplaced.name ?? "",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subTitleText:
                                                  "(${pmmToBeReplaced.userName})\nRefreral : ${pmmToBeReplaced.directIncome * 500}",
                                              icon: Text(
                                                  "r${rowNumber(pmmToBeReplaced.memberPosition ?? 0) + 1}p${rowPosition(pmmToBeReplaced.memberPosition!)} = ${pmmToBeReplaced.memberPosition}"),
                                              avatar: GFAvatar(
                                                backgroundImage: pmmToBeReplaced
                                                            .profilePhotoUrl !=
                                                        null
                                                    ? CachedNetworkImageProvider(
                                                        pmmToBeReplaced
                                                            .profilePhotoUrl!)
                                                    : null,
                                              ),
                                              onTap: () async {
                                                await waitMilli(200);
                                                isSelected.value = true;
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                            ),
                                            if (isSelected.value)
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    await waitMilli(150);

                                                    Get.back();
                                                    pmm2.isPaid = true;
                                                    pmm2.memberPosition =
                                                        pmmToBeReplaced
                                                            .memberPosition;
                                                    await pmm2.docRef!
                                                        .update(pmm2.toMap());
                                                    await primeMOs
                                                        .primeMembersCR()
                                                        .where(
                                                            primeMOs.memberID,
                                                            isEqualTo: pmm2
                                                                .refMemberId)
                                                        .limit(1)
                                                        .get()
                                                        .then((qs) async {
                                                      if (qs.docs.isNotEmpty) {
                                                        var pmRR2 =
                                                            PrimeMemberModel
                                                                .fromMap(qs
                                                                    .docs.first
                                                                    .data());
                                                        pmRR2.directIncome =
                                                            pmRR2.directIncome +
                                                                1;
                                                        await qs.docs.first
                                                            .reference
                                                            .update(
                                                                pmRR2.toMap());
                                                      }
                                                    });
                                                    pmmToBeReplaced
                                                        .memberPosition = null;
                                                    pmmToBeReplaced.isPaid =
                                                        null;
                                                    await pmmToBeReplaced
                                                        .docRef!
                                                        .update(pmmToBeReplaced
                                                            .toMap());
                                                    await primeMOs
                                                        .primeMembersCR()
                                                        .where(
                                                            primeMOs.memberID,
                                                            isEqualTo:
                                                                pmmToBeReplaced
                                                                    .refMemberId)
                                                        .limit(1)
                                                        .get()
                                                        .then((qs) async {
                                                      if (qs.docs.isNotEmpty) {
                                                        var pmm2RR2 =
                                                            PrimeMemberModel
                                                                .fromMap(qs
                                                                    .docs.first
                                                                    .data());
                                                        pmm2RR2.directIncome =
                                                            pmm2RR2.directIncome -
                                                                1;
                                                        await qs.docs.first
                                                            .reference
                                                            .update(pmm2RR2
                                                                .toMap());
                                                      }
                                                    });
                                                  },
                                                  child: const Text("Confirm"))
                                          ],
                                        ));
                                  })),
                            ],
                          ),
                        ),
                      ));
                    },
                    child: pmm2.memberPosition == null
                        ? const Text("Replace")
                        : const Icon(
                            MdiIcons.checkCircle,
                            color: Colors.green,
                          )),
              ),
            ],
          );
        });
  }

  Future<void> addPrimePosition(PrimeMemberModel pmm) async {
    await primeMOs
        .primeMembersCR()
        .orderBy(primeMOs.memberPosition, descending: true)
        .limit(1)
        .get()
        .then((qs) async {
      if (qs.docs.isNotEmpty) {
        var pmLast = PrimeMemberModel.fromMap(qs.docs.first.data());
        pmm.memberPosition = pmLast.memberPosition! + 1;
        pmm.isPaid = true;
        await pmm.docRef!.update(pmm.toMap());

        // Add direct income to his referrar
        await primeMOs
            .primeMembersCR()
            .where(primeMOs.memberID, isEqualTo: pmm.refMemberId)
            .limit(1)
            .get()
            .then((qsf) async {
          if (qsf.docs.isNotEmpty) {
            var pmf = PrimeMemberModel.fromMap(qsf.docs.first.data());

            pmf.directIncome = pmf.directIncome + 1;
            pmf.docRef = qsf.docs.first.reference;
            Get.snackbar("title", pmf.toMap().toString(),
                duration: const Duration(seconds: 6));
            await pmf.docRef!.update(pmf.toMap());
          }
        });
      }
    });
  }
}

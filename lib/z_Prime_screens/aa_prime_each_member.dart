import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:myshopadmin/Models/prime_member_model.dart';
import 'package:myshopadmin/custom%20widgets/firestore_listview_builder.dart';
import 'package:myshopadmin/matrix/matrix_history.dart';
import 'package:myshopadmin/matrix/matrix_income.dart';

import '../../matrix/positions.dart';

class PrimeMemberEachPage extends StatefulWidget {
  final PrimeMemberModel pmm;
  const PrimeMemberEachPage(this.pmm, {Key? key}) : super(key: key);

  @override
  State<PrimeMemberEachPage> createState() => _PrimeMemberEachPageState();
}

class _PrimeMemberEachPageState extends State<PrimeMemberEachPage>
    with SingleTickerProviderStateMixin {
  late TabController tabC;
  @override
  void initState() {
    super.initState();
    tabC = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrimeMemberModel?>(
        future: primeMOs.getLastPrimeMemberModel(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var pmmLast = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.pmm.name}",
                        textScaleFactor: 0.8,
                      ),
                      Text(
                        "r${rowNumber(widget.pmm.memberPosition!) + 1}p${rowPosition(widget.pmm.memberPosition!)}",
                        textScaleFactor: 0.8,
                      ),
                    ],
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(36.0),
                    child: TabBar(
                      controller: tabC,
                      indicatorColor: Colors.white70,
                      tabs: [
                        SizedBox(
                            height: 30,
                            child: Center(
                                child: Text(
                                    "Direct (${widget.pmm.directIncome * 500})"))),
                        SizedBox(
                            height: 30,
                            child: Center(
                                child: Text(
                                    "Matrix (${matrixIncome(widget.pmm.memberPosition!, pmmLast.memberPosition!)})"))),
                      ],
                      indicatorWeight: 2.5,
                    ),
                  )),
              body: Padding(
                padding: const EdgeInsets.all(2.0),
                child: TabBarView(
                  controller: tabC,
                  children: [
                    refMembers(pmmLast),
                    matrixList(widget.pmm, pmmLast),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: const GFLoader(),
            );
          }
        });
  }

  Widget refMembers(PrimeMemberModel pmLast) {
    return FirestoreListViewBuilder(
      query: primeMOs
          .primeMembersCR()
          .where(primeMOs.refMemberId, isEqualTo: widget.pmm.memberID)
          .orderBy(primeMOs.memberPosition, descending: false),
      builder: (snapshot) {
        var pm = PrimeMemberModel.fromMap(snapshot.data());
        pm.docRef = snapshot.reference;
        return GFListTile(
          title: Text(
            pm.name ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: Text(
              "r${rowNumber(pm.memberPosition ?? 0) + 1}p${rowPosition(pm.memberPosition!)} = ${pm.memberPosition}"),
          avatar: GFAvatar(
            backgroundImage: pm.profilePhotoUrl != null
                ? CachedNetworkImageProvider(pm.profilePhotoUrl!)
                : null,
          ),
        );
      },
    );
  }

  Widget matrixList(PrimeMemberModel pm, PrimeMemberModel pmLast) {
    var listMh = matrixHistory(pm.memberPosition!, pmLast.memberPosition!);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: listMh.length,
        itemBuilder: (context, index) {
          var mh = listMh[index];
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: primeMOs
                  .primeMembersCR()
                  .where(primeMOs.memberPosition, isEqualTo: mh.memPos)
                  .limit(1)
                  .snapshots(),
              builder: (context, mhSnap) {
                if (mhSnap.hasData && mhSnap.data!.docs.isNotEmpty) {
                  var umMhMember =
                      PrimeMemberModel.fromMap(mhSnap.data!.docs.first.data());
                  umMhMember.docRef = mhSnap.data!.docs.first.reference;
                  return GFListTile(
                    titleText:
                        "${mh.isPlus ? 'From' : 'To'} r${rowNumber(umMhMember.memberPosition!) + 1}p${rowPosition(umMhMember.memberPosition!)}",
                    icon: Text("${mh.isPlus ? '+' : '-'} ${mh.amount}"),
                  );
                } else if (mhSnap.hasData && mhSnap.data!.docs.isEmpty) {
                  return GFListTile(
                    titleText: "To company",
                    icon: Text("${mh.isPlus ? '+' : '-'} ${mh.amount}"),
                  );
                }
                return const GFListTile(title: Text("Loading..."));
              });
        });
  }
}

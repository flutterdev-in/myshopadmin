import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class StreamSingleQueryBuilder extends StatelessWidget {
  final Query<Map<String, dynamic>> query;
  final Widget Function(
      BuildContext, QueryDocumentSnapshot<Map<String, dynamic>>) docBuilder;
  final Widget? loadingW;
  final Widget? noResultsW;
  final Widget? errorW;
  const StreamSingleQueryBuilder({
    Key? key,
    required this.query,
    required this.docBuilder,
    this.loadingW,
    this.noResultsW,
    this.errorW,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: query.limit(1).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return errorW ?? const Text("Error while fetching data");
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return noResultsW ?? const Text("Data not exits");
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return docBuilder(context, snapshot.data!.docs.first);
          }
          return loadingW ?? const GFLoader();
        });
  }
}

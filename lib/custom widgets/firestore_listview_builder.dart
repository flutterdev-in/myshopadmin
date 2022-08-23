import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:getwidget/getwidget.dart';

class FirestoreListViewBuilder extends StatelessWidget {
  final Query<Map<String, dynamic>> query;
  final Widget Function(
      BuildContext, QueryDocumentSnapshot<Map<String, dynamic>>) builder;
  final Widget? loadingW;
  final Widget? noResultsW;
  final Widget? errorW;
  final int pageSize;
  final bool shrinkWrap;
  const FirestoreListViewBuilder({
    Key? key,
    required this.query,
    required this.builder,
    this.loadingW,
    this.noResultsW,
    this.errorW,
    this.pageSize = 8,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Map<String, dynamic>>(
        pageSize: pageSize,
        query: query,
        builder: (context, snapshot, _) {
          if (snapshot.hasData && snapshot.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: noResultsW ?? const Text("No results"),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: errorW ?? const Text("Error while fetching data"),
            );
          }
          if (snapshot.hasData && snapshot.docs.isNotEmpty) {
            return ListView.builder(
                shrinkWrap: shrinkWrap,
                itemCount: snapshot.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                    snapshot.fetchMore();
                  }
                  var qds = snapshot.docs[index];
                  return builder(context, qds);
                });
          }
          return loadingW ?? const GFLoader();
        });
  }
}

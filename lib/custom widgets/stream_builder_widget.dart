import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class StreamDocBuilder extends StatelessWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final Widget Function(BuildContext, DocumentSnapshot<Map<String, dynamic>>)
      docBuilder;
  final Widget? loadingW;
  final Widget? noResultsW;
  final Widget? errorW;
  const StreamDocBuilder({
    Key? key,
    required this.docRef,
    required this.docBuilder,
    this.loadingW,
    this.noResultsW,
    this.errorW,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return errorW ?? const Text("Error while fetching data");
          }
          if (!snapshot.hasData ||
              (snapshot.hasData &&
                  (!snapshot.data!.exists || snapshot.data!.data() == null))) {
            return noResultsW ?? const Text("Data not exits");
          }
          if (snapshot.hasData &&
              snapshot.data!.exists &&
              snapshot.data!.data() != null) {
            return docBuilder(context, snapshot.data!);
          }

          return loadingW ?? const GFLoader();
        });
  }
}

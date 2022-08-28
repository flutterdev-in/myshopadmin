import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:myshopadmin/Models/kyc_model.dart';
import 'package:myshopadmin/Models/prime_member_model.dart';
import 'package:myshopadmin/custom%20widgets/stream_builder_widget.dart';
import 'package:myshopadmin/dart/useful_functions.dart';

class KycVerificationPage extends StatelessWidget {
  final KycModel kmOld;
  final PrimeMemberModel pmm;
  const KycVerificationPage(this.kmOld, this.pmm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const testUrl =
        "https://firebasestorage.googleapis.com/v0/b/mlm-app-vijayawada.appspot.com/o/products%2FZYNrW1fzPA98DnNgQvRV%2F26_Aug_22_00.jpg?alt=media&token=153d1c5e-aa78-4284-939c-402ce37129d3";
    return Scaffold(
        appBar: AppBar(title: Text('Kyc : ${pmm.name}')),
        body: StreamDocBuilder(
            stream: kmOld.docRef!,
            builder: (context, snapshot) {
              var km = KycModel.fromMap(snapshot.data()!);
              km.docRef = snapshot.reference;
              return Column(
                children: [
                  Expanded(
                      child: ListView(
                    children: [
                      comments(km),
                      aadhaarCard(km),
                      panCard(km),
                      bankBook(km),
                      accountNumber(km),
                      ifsc(km),
                      const SizedBox(height: 50),
                    ],
                  ))
                ],
              );
            }));
  }

  Widget comments(KycModel km) {
    var tc = TextEditingController();
    tc.text = km.adminComments ?? '';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: tc,
        maxLines: null,
        decoration: const InputDecoration(
          labelText: "Admin comments",
        ),
        onChanged: (value) {
          afterDebounce(
              seconds: 3,
              after: () async {
                km.adminComments = tc.text;

                km.docRef!.update(km.toMap());
              });
        },
      ),
    );
  }

  Widget aadhaarCard(KycModel km) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Aadhar card"),
        ),
        km.aadhaarUrl == null
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Not uploaded"),
              )
            : Column(
                children: [
                  LimitedBox(
                      maxHeight: 200,
                      child: CachedNetworkImage(imageUrl: km.aadhaarUrl!)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GFButton(
                        onPressed: () async {
                          if (km.aadhaarStatus == kycMOs.invalid) {
                            km.aadhaarStatus = kycMOs.uploaded;
                            km.docRef!.update(km.toMap());
                          } else {
                            km.aadhaarStatus = kycMOs.invalid;
                            km.docRef!.update(km.toMap());
                          }
                        },
                        type: km.aadhaarStatus == kycMOs.invalid
                            ? GFButtonType.solid
                            : GFButtonType.outline,
                        child: const Text("Invalid"),
                      ),
                      GFButton(
                        onPressed: () async {
                          if (km.aadhaarStatus == kycMOs.verified) {
                            km.aadhaarStatus = kycMOs.uploaded;
                            km.docRef!.update(km.toMap());
                          } else {
                            km.aadhaarStatus = kycMOs.verified;
                            km.docRef!.update(km.toMap());
                          }
                        },
                        type: km.aadhaarStatus == kycMOs.verified
                            ? GFButtonType.solid
                            : GFButtonType.outline,
                        child: const Text("Verified"),
                      ),
                    ],
                  ),
                ],
              )
      ],
    ));
  }

  Widget panCard(KycModel km) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Pan card"),
        ),
        km.panCardUrl == null
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Not uploaded"),
              )
            : Column(
                children: [
                  LimitedBox(
                      maxHeight: 200,
                      child: CachedNetworkImage(imageUrl: km.panCardUrl!)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GFButton(
                        onPressed: () async {
                          if (km.panCardStatus == kycMOs.invalid) {
                            km.panCardStatus = kycMOs.uploaded;
                            km.docRef!.update(km.toMap());
                          } else {
                            km.panCardStatus = kycMOs.invalid;
                            km.docRef!.update(km.toMap());
                          }
                        },
                        type: km.panCardStatus == kycMOs.invalid
                            ? GFButtonType.solid
                            : GFButtonType.outline,
                        child: const Text("Invalid"),
                      ),
                      GFButton(
                        onPressed: () async {
                          if (km.panCardStatus == kycMOs.verified) {
                            km.panCardStatus = kycMOs.uploaded;
                            km.docRef!.update(km.toMap());
                          } else {
                            km.panCardStatus = kycMOs.verified;
                            km.docRef!.update(km.toMap());
                          }
                        },
                        type: km.panCardStatus == kycMOs.verified
                            ? GFButtonType.solid
                            : GFButtonType.outline,
                        child: const Text("Verified"),
                      ),
                    ],
                  ),
                ],
              )
      ],
    ));
  }

  Widget bankBook(KycModel km) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Check / Bank passbook"),
        ),
        km.checkOrPassbookUrl == null
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Not uploaded"),
              )
            : Column(
                children: [
                  LimitedBox(
                      maxHeight: 200,
                      child:
                          CachedNetworkImage(imageUrl: km.checkOrPassbookUrl!)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GFButton(
                        onPressed: () async {
                          if (km.checkOrPassbookStatus == kycMOs.invalid) {
                            km.checkOrPassbookStatus = kycMOs.uploaded;
                            km.docRef!.update(km.toMap());
                          } else {
                            km.checkOrPassbookStatus = kycMOs.invalid;
                            km.docRef!.update(km.toMap());
                          }
                        },
                        type: km.checkOrPassbookStatus == kycMOs.invalid
                            ? GFButtonType.solid
                            : GFButtonType.outline,
                        child: const Text("Invalid"),
                      ),
                      GFButton(
                        onPressed: () async {
                          if (km.checkOrPassbookStatus == kycMOs.verified) {
                            km.checkOrPassbookStatus = kycMOs.uploaded;
                            km.docRef!.update(km.toMap());
                          } else {
                            km.checkOrPassbookStatus = kycMOs.verified;
                            km.docRef!.update(km.toMap());
                          }
                        },
                        type: km.checkOrPassbookStatus == kycMOs.verified
                            ? GFButtonType.solid
                            : GFButtonType.outline,
                        child: const Text("Verified"),
                      ),
                    ],
                  ),
                ],
              )
      ],
    ));
  }

  Widget accountNumber(KycModel km) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Account number"),
        ),
        km.accountNumber == null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: const [
                    Text("Not uploaded"),
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(km.accountNumber!),
                        if (km.bankName != null) Text(km.bankName!),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GFButton(
                        onPressed: () async {
                          if (km.accountNumberStatus == kycMOs.invalid) {
                            km.accountNumberStatus = kycMOs.uploaded;
                            km.docRef!.update(km.toMap());
                          } else {
                            km.accountNumberStatus = kycMOs.invalid;
                            km.docRef!.update(km.toMap());
                          }
                        },
                        type: km.accountNumberStatus == kycMOs.invalid
                            ? GFButtonType.solid
                            : GFButtonType.outline,
                        child: const Text("Invalid"),
                      ),
                      GFButton(
                        onPressed: () async {
                          if (km.accountNumberStatus == kycMOs.verified) {
                            km.accountNumberStatus = kycMOs.uploaded;
                            km.docRef!.update(km.toMap());
                          } else {
                            km.accountNumberStatus = kycMOs.verified;
                            km.docRef!.update(km.toMap());
                          }
                        },
                        type: km.accountNumberStatus == kycMOs.verified
                            ? GFButtonType.solid
                            : GFButtonType.outline,
                        child: const Text("Verified"),
                      ),
                    ],
                  ),
                ],
              ),
      ],
    ));
  }

  Widget ifsc(KycModel km) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("IFSC Code"),
        ),
        km.ifsc == null
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Not uploaded"),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(km.ifsc!),
                        FutureBuilder<String?>(
                            future: kycMOs.getIFSCdetails(km.ifsc!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                return Text(snapshot.data!);
                              } else {
                                return const Text(
                                    "Error while fetching IFSC details");
                              }
                            })
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GFButton(
                        onPressed: () async {
                          if (km.ifscStatus == kycMOs.invalid) {
                            km.ifscStatus = kycMOs.uploaded;
                            km.docRef!.update(km.toMap());
                          } else {
                            km.ifscStatus = kycMOs.invalid;
                            km.docRef!.update(km.toMap());
                          }
                        },
                        type: km.ifscStatus == kycMOs.invalid
                            ? GFButtonType.solid
                            : GFButtonType.outline,
                        child: const Text("Invalid"),
                      ),
                      GFButton(
                        onPressed: () async {
                          if (km.ifscStatus == kycMOs.verified) {
                            km.ifscStatus = kycMOs.uploaded;
                            km.docRef!.update(km.toMap());
                          } else {
                            km.ifscStatus = kycMOs.verified;
                            km.docRef!.update(km.toMap());
                          }
                        },
                        type: km.ifsc == kycMOs.verified
                            ? GFButtonType.solid
                            : GFButtonType.outline,
                        child: const Text("Verified"),
                      ),
                    ],
                  ),
                ],
              ),
      ],
    ));
  }
}

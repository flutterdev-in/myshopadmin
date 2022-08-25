import 'package:flutter/material.dart';
import 'package:myshopadmin/Models/prices_model.dart';
import 'package:myshopadmin/Models/product_model.dart';
import 'package:myshopadmin/custom%20widgets/stream_builder_widget.dart';
import 'package:myshopadmin/dart/useful_functions.dart';
import 'package:collection/collection.dart';

import '../../dart/repeatFunctions.dart';

class EditPrices extends StatelessWidget {
  final ProductModel pmOld;
  const EditPrices(this.pmOld, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit prices'),
      ),
      body: StreamDocBuilder(
          docRef: pmOld.docRef!,
          docBuilder: (context, snapshot) {
            var pm = ProductModel.fromMap(snapshot.data()!);
            pm.docRef = snapshot.reference;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(pm.name),
                  ),
                  TextButton(
                      onPressed: () async {
                        var priceModel = PricesModel(
                            priceName: "",
                            mrp: 0,
                            price: 0,
                            maxPerOrder: 0,
                            stockAvailable: 0);
                        var l = pm.listPrices ?? [];
                        l.add(priceModel);
                        pm.listPrices = l;

                        await productMOS.updateProductDoc(pm);
                      },
                      child: const Text("Add price model")),
                  const SizedBox(height: 5),
                  if (pm.highPrice != pm.lowPrice)
                    Text("Price : from ${pm.highPrice} to ${pm.lowPrice}"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                    child: TextField(
                      controller: textEditingController(pm.priceType),
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: "Price type",
                      ),
                      onChanged: (value) {
                        afterDebounce(after: () async {
                          pm.priceType = value;

                          await productMOS.updateProductDoc(pm);
                        });
                      },
                    ),
                  ),
                  if (pm.listPrices != null)
                    Expanded(
                      child: ListView(
                        children: pm.listPrices!
                            .mapIndexed((index, element) => priceW(index, pm))
                            .toList(),
                      ),
                    ),
                ],
              ),
            );
          }),
    );
  }

  Widget priceW(int priceIndex, ProductModel productModel) {
    var prm = productModel.listPrices![priceIndex];
    return Stack(
      children: [
        Column(
          children: [
            Container(
              color: Colors.brown.shade50,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextField(
                      controller: textEditingController(prm.priceName),
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "${priceIndex + 1}. Name",
                      ),
                      onChanged: (value) {
                        afterDebounce(after: () async {
                          prm.priceName = value;
                          productModel.listPrices![priceIndex] = prm;
                          await productMOS.updateProductDoc(productModel);
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller:
                              textEditingController(prm.price.toString()),
                          decoration: const InputDecoration(
                            labelText: "Price",
                          ),
                          onChanged: (value) {
                            afterDebounce(after: () async {
                              prm.price = int.tryParse(value) ?? prm.price;
                              productModel.listPrices![priceIndex] = prm;
                              await productMOS.updateProductDoc(productModel);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: textEditingController(prm.mrp.toString()),
                          decoration: const InputDecoration(
                            labelText: "MRP",
                          ),
                          onChanged: (value) {
                            afterDebounce(after: () async {
                              prm.mrp = int.tryParse(value) ?? prm.mrp;
                              productModel.listPrices![priceIndex] = prm;
                              await productMOS.updateProductDoc(productModel);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller:
                              textEditingController(prm.maxPerOrder.toString()),
                          decoration: const InputDecoration(
                            labelText: "Max per order",
                          ),
                          onChanged: (value) {
                            afterDebounce(after: () async {
                              prm.maxPerOrder =
                                  int.tryParse(value) ?? prm.maxPerOrder;
                              productModel.listPrices![priceIndex] = prm;
                              await productMOS.updateProductDoc(productModel);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: textEditingController(
                              prm.stockAvailable.toString()),
                          decoration: const InputDecoration(
                            labelText: "Stock available",
                          ),
                          onChanged: (value) {
                            afterDebounce(after: () async {
                              prm.stockAvailable =
                                  int.tryParse(value) ?? prm.stockAvailable;
                              productModel.listPrices![priceIndex] = prm;
                              await productMOS.updateProductDoc(productModel);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        Positioned(
            top: 0,
            right: 0,
            child: TextButton(
                onPressed: () async {
                  await waitMilli();
                  var l = productModel.listPrices ?? [];
                  l.removeAt(priceIndex);
                  productModel.listPrices = l;
                  productMOS.updateProductDoc(productModel);
                },
                child: const Text("Delete"))),
      ],
    );
  }
}

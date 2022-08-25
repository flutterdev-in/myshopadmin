class PricesModel {
  String priceName;
  num mrp;
  num? price;
  int stockAvailable;
  int maxPerOrder;

  PricesModel({
    required this.priceName,
    required this.mrp,
    required this.price,
    required this.maxPerOrder,
    required this.stockAvailable,
  });

  Map<String, dynamic> toMap() {
    return {
      pricesMOs.priceName: priceName,
      pricesMOs.mrp: mrp,
      pricesMOs.price: price,
      pricesMOs.maxPerOrder: maxPerOrder,
      pricesMOs.stockAvailable: stockAvailable,
    };
  }

  factory PricesModel.fromMap(Map<String, dynamic> pricesMap) {
    return PricesModel(
      priceName: pricesMap[pricesMOs.priceName],
      mrp: pricesMap[pricesMOs.mrp],
      price: pricesMap[pricesMOs.price],
      maxPerOrder: pricesMap[pricesMOs.maxPerOrder],
      stockAvailable: pricesMap[pricesMOs.stockAvailable],
    );
  }
}

PricesModelObjects pricesMOs = PricesModelObjects();

class PricesModelObjects {
  final priceName = "priceName";
  final price = "price";
  final mrp = "mrp";
  final maxPerOrder = "maxPerOrder";
  final stockAvailable = "stockAvailable";

  List<num> minMaxPrice(List<PricesModel> listPrices) {
    var listPr = listPrices.map((e) => e.price ?? e.mrp).toList();
    listPr.sort();
    return [listPr.first, listPr.last];
  }
}

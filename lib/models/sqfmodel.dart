class ItemModel {
  int id;
  String productName;
  double quantity;
  String unit;
  String dtInfo;
  String shopname;

  ItemModel({
    this.id,
    this.productName,
    this.quantity,
    this.unit,
    this.dtInfo,
    this.shopname,
  });

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'productname': productName,
      'quantity': quantity,
      'unit': unit,
      'dateandtime': dtInfo,
      'shopname': shopname
    };
  }
}

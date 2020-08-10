import 'package:flutter/cupertino.dart';
import '../models/items.dart';

class ItemManager extends ChangeNotifier {
  List<Items> _itemList = [];

  List<Items> get list {
    return [..._itemList.reversed];
  }

  void addItems(Items items,String unit) {
    _itemList.add(Items(
        productName: items.productName,
        quantity: items.quantity,
        unit: unit,
        shopName: items.shopName,
        marker: 1));
    notifyListeners();
  }

  Items getInstanceByName(String name) {
    return _itemList.firstWhere((element) => element.productName == name);
  }

  void updateItemdata(String product, Items items) {
    var index =
        _itemList.indexWhere((element) => element.productName == product);
    var obj = _itemList[index];
    if (obj != null) {
      obj.productName = items.productName;
      obj.marker = 1;
      obj.shopName = items.shopName;
      obj.unit = items.unit;
      obj.quantity = items.quantity;
    }
    notifyListeners();
  }
  void deleteItem(String prodName){
    var index = _itemList.indexWhere((element) => element.productName == prodName);
    _itemList.removeAt(index);
    notifyListeners();
  }
  void cleanData(){
    _itemList.clear();
    notifyListeners();
  }
}

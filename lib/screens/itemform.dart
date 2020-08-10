import 'package:flutter/services.dart';
import 'package:shoppinglistapp/screens/cartpage.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppinglistapp/models/items.dart';
import '../providerpackage/itemprovider.dart';
import 'package:shoppinglistapp/providerpackage/itemprovider.dart';
import 'package:shoppinglistapp/models/sqfmodel.dart';
import 'package:shoppinglistapp/dbmanager/historydbmanager.dart';
import 'package:shoppinglistapp/dbmanager/itemsdbmanager.dart';

class ItemFormPage extends StatefulWidget {
  static final String id = 'formpage';

  @override
  _ItemFormPageState createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final formKey = GlobalKey<FormState>();
  String unit = 'Kg';
  final scaffKey = GlobalKey<ScaffoldState>();
  int count = 0;
  final Dbmanager dbManager = new Dbmanager();
  final HistoryDbManager dbHistoryManager = new HistoryDbManager();
  final focusOty = FocusNode();
  final focusShop = FocusNode();
  final textControllerProd = TextEditingController();
  final textControllerQty = TextEditingController();
  final textControllerShop = TextEditingController();
  String currDnT = DateFormat('dd/MM/yyyy hh:mm a E').format(DateTime.now());
  List<DropdownMenuItem<String>> units = [
    DropdownMenuItem(
      value: 'Kg',
      child: Text('kg'),
    ),
    DropdownMenuItem(
      value: 'gm',
      child: Text('gm'),
    ),
    DropdownMenuItem(
      value: 'litre',
      child: Text('ltr'),
    ),
    DropdownMenuItem(
      value: 'ml',
      child: Text('ml'),
    ),
    DropdownMenuItem(
      value: 'dozen',
      child: Text('Dozen'),
    ),
    DropdownMenuItem(
      value: 'Piece',
      child: Text('piece'),
    ),
    DropdownMenuItem(
      value: 'Box',
      child: Text('Box'),
    ),
    DropdownMenuItem(
      value: 'Set',
      child: Text('Set'),
    ),
    DropdownMenuItem(
      value: 'Pair',
      child: Text('Pair'),
    ),
    DropdownMenuItem(
      value: 'Bottle',
      child: Text('Bottle'),
    ),
    DropdownMenuItem(
      value: 'Sachet',
      child: Text('Sachet'),
    ),
    DropdownMenuItem(
      value: 'Packet',
      child: Text('Packet'),
    ),
  ];
  var items = Items(productName: '', quantity: 0.0, unit: '', shopName: '');

  void addToHistoryDatabase() {
    var historyList = Provider.of<ItemManager>(context, listen: false).list;
    print('history list length ${historyList.length}');
    historyList.forEach((element) {
      ItemModel itemsData = new ItemModel(
        productName: element.productName,
        quantity: element.quantity,
        unit: element.unit,
        shopname: element.shopName,
        dtInfo: currDnT,
      );
      dbHistoryManager
          .insert(itemsData)
          .then((value) => {print('added to history successfully!!')});
    });
  }

  void addToSqlDatabase() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Navigator.pop(context);
    var listMade = Provider.of<ItemManager>(context, listen: false).list;
    listMade.forEach((element) {
      ItemModel itemsData = new ItemModel(
        productName: element.productName,
        quantity: element.quantity,
        unit: element.unit,
        shopname: element.shopName,
        dtInfo: currDnT,
      );
      dbManager.insert(itemsData).then((id) => {print('entry added at $id')});
    });
    Provider.of<ItemManager>(context, listen: false).cleanData();
  }

  void confirmEntry() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Meri Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Press continue to create list'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            color: Color(0xffac7ffc),
          ),
          FlatButton(
            onPressed: () {
              if (count < 0 || count == 0) {
                Toast.show(
                  'List is Empty',
                  context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                );
                return;
              }

              addToHistoryDatabase();
              addToSqlDatabase();
              Navigator.pushReplacementNamed(context, CartPage.id);
            },
            child: Text(
              'Create',
              style: TextStyle(color: Colors.white),
            ),
            color: Color(0xffac7ffc),
          ),
        ],
      ),
    );
  }

  void updateItems(String prodAsId) {
    final formKey = GlobalKey<FormState>();
    var obj = Provider.of<ItemManager>(context, listen: false)
        .getInstanceByName(prodAsId);
    var items = Items(productName: '', quantity: 0.0, unit: '', shopName: '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit..',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    initialValue: obj.productName,
                    decoration: InputDecoration(labelText: 'ProductName'),
                    onSaved: (val) {
                      items = Items(
                          productName: val,
                          quantity: items.quantity,
                          unit: items.unit,
                          shopName: items.shopName);
                    },
                  ),
                  TextFormField(
                    initialValue: obj.quantity.toString(),
                    decoration: InputDecoration(labelText: 'quantity'),
                    onSaved: (val) {
                      items = Items(
                          productName: items.productName,
                          quantity: double.tryParse(val),
                          unit: items.unit,
                          shopName: items.shopName);
                    },
                  ),
                  TextFormField(
                    initialValue: obj.unit,
                    decoration: InputDecoration(labelText: 'unit'),
                    onSaved: (val) {
                      items = Items(
                          productName: items.productName,
                          quantity: items.quantity,
                          unit: val,
                          shopName: items.shopName);
                    },
                  ),
                  TextFormField(
                    initialValue: obj.shopName,
                    decoration: InputDecoration(labelText: 'Place'),
                    onSaved: (val) {
                      items = Items(
                          productName: items.productName,
                          quantity: items.quantity,
                          unit: items.unit,
                          shopName: val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              formKey.currentState.save();
              Provider.of<ItemManager>(context, listen: false)
                  .updateItemdata(prodAsId, items);
              Navigator.of(context).pop();
            },
            child: Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
            color: Color(0xffac7ffc),
          ),
          RaisedButton(
            onPressed: () {
              formKey.currentState.save();
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            color: Color(0xffac7ffc),
          ),
        ],
      ),
    );
  }

  void _onSave() {
    bool isValid = formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState.save();
    Provider.of<ItemManager>(context, listen: false).addItems(items, unit);
    setState(() {
      count += 1;
    });
    textControllerProd.clear();
    textControllerQty.clear();
    textControllerShop.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffKey,
      appBar: AppBar(
        title: Text('Create List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done_outline),
            onPressed: confirmEntry,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(focusOty);
                },
                controller: textControllerProd,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                ),
                onSaved: (val) {
                  items = Items(
                      productName: val,
                      unit: items.unit,
                      shopName: items.shopName,
                      quantity: items.quantity);
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Required field';
                  } else if (val.length < 2) {
                    return 'Shoudle be more than 2 character';
                  } else if (val.length > 30) {
                    return 'Name too long...';
                  } else {
                    return null;
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: textControllerQty,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: focusOty,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(focusShop);
                      },
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                      ),
                      onSaved: (val) {
                        items = Items(
                          productName: items.productName,
                          unit: items.unit,
                          shopName: items.shopName,
                          quantity: double.tryParse(val),
                        );
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'required files';
                        } else if (double.tryParse(val) == null) {
                          return 'Quantity is wrong';
                        }
                        return null;
                      },
                    ),
                  ),
                  DropdownButton(
                      value: unit,
                      items: units,
                      onChanged: (val) {
                        setState(() {
                          unit = val;
                        });
                      },
                      icon: Icon(Icons.arrow_drop_down_circle),
                      focusColor: Colors.blue),
                ],
              ),
              TextFormField(

                controller: textControllerShop,
                focusNode: focusShop,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    labelText: 'Shop Name / Location (optional)'),
                onSaved: (val) {
                  items = Items(
                      productName: items.productName,
                      unit: items.unit,
                      shopName: val,
                      quantity: items.quantity);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: RaisedButton(
                  onPressed: _onSave,
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color(0xffac7ffc),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Consumer<ItemManager>(
                    builder: (context, data, _) => ListView.builder(
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (dir) {
                            return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Meri Cart',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Text('Confirm delete'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      //deny the request of deletion
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Color(0xffac7ffc),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      //confirm's the deletion
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Color(0xffac7ffc),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (dir) {
                            Provider.of<ItemManager>(context, listen: false)
                                .deleteItem(data.list[index].productName);
                          },
                          background: Container(
                            color: Color(0xff93b2fe),
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Icon(
                                Icons.delete_forever,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Card(
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0),
                                        child: Text(
                                          data.list[index].productName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0),
                                        child: RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Quantity:-',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text:
                                                    '  ${data.list[index].quantity}'
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text:
                                                    '   ${data.list[index].unit}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Shop Name:- ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:
                                                  '   ${data.list[index].shopName}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                                color: Color(0xff93b2fe),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Color(0xff93b2fe),
                                    ),
                                    onPressed: () {
                                      updateItems(data.list[index].productName);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: data.list.length,
                      shrinkWrap: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shoppinglistapp/dbmanager/itemsdbmanager.dart';
import 'package:shoppinglistapp/models/sqfmodel.dart';
import 'package:shoppinglistapp/screens/historypage.dart';
import 'package:shoppinglistapp/screens/itemform.dart';

class CartPage extends StatefulWidget {
  static final String id = 'cartpage';

  @override
  _StateCartPage createState() => _StateCartPage();
}

class _StateCartPage extends State<CartPage> {
  final Dbmanager dbmanager = new Dbmanager();
  final scaffKey = GlobalKey<ScaffoldState>();
  List<ItemModel> listdata = [];

  Widget EmptyListScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            CupertinoIcons.shopping_cart,
            size: 150.0,
            color: Color(0xffac7ffc),
          ),
          Text(
            'Your list is Empty',
            style: TextStyle(
                fontFamily: 'Signatra',
                letterSpacing: 1.5,
                fontSize: 50.0,
                color: Color(0xffac7ffc)),
          ),
        ],
      ),
    );
  }

  Future getDataFromDb() async {
    var data = await dbmanager.getQuery();
    setState(() {
      listdata = data;
    });
  }

  Future onFresh() async {
    setState(() {});
    await getDataFromDb();
  }

  @override
  void initState() {
    super.initState();
    getDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onFresh,
      child: Scaffold(
        key: scaffKey,
        appBar: AppBar(
          title: Text('My List'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[
                  Color(0xfff595b8),
                  Color(0xffac7ffc),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                size: 25.0,
              ),
              onPressed: () {
                Navigator.pushNamed(context, ItemFormPage.id);
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      child: Image.asset(
                        'images/mericartlogo.png',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Meri Cart',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Color(0xffac7ffc), Color(0xfff595b8)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, ItemFormPage.id);
                },
                child: ListTile(
                  leading: Icon(Icons.add_shopping_cart),
                  title: Text(
                    'Make List',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  thickness: 1.0,
                  color: Colors.black54,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, HistoryPage.id);
                },
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text(
                    'List-History',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  thickness: 1.0,
                  color: Colors.black54,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Meri cart',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text('Want to exit??'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                          ),
                          color: Color(0xffac7ffc),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            exit(0);
                          },
                          child: Text(
                            'Exit',
                          ),
                          color: Color(0xffac7ffc),
                        ),
                      ],
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(
                    'Exit',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  thickness: 1.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        body: listdata.isEmpty
            ? EmptyListScreen()
            : ListView.builder(
                itemBuilder: (cont, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (dir) {
                      dbmanager
                          .delete(listdata[index].id)
                          .then((value) => {print('W')});
                      setState(() {
                        listdata.removeAt(index);
                      });
                      SnackBar snackBar = SnackBar(
                        content: Text(
                          'Item Purchased',
                          style: TextStyle(color: Colors.black87),
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xffac7ffc),
                      );
                      scaffKey.currentState.hideCurrentSnackBar();
                      scaffKey.currentState.showSnackBar(snackBar);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  listdata[index].productName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 17.0),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Quantity:-',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                              '  ${listdata[index].quantity.toString()} ${listdata[index].unit}',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Store Name / Location:-',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: '  ${listdata[index].shopname}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: listdata.length,
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    dbmanager.closeConnection();
  }
}

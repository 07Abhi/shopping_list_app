import 'package:shoppinglistapp/dbmanager/historydbmanager.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglistapp/models/sqfmodel.dart';

class HistoryPage extends StatefulWidget {
  static final String id = 'historypage';

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryDbManager historyDb = new HistoryDbManager();
  List<ItemModel> listdata = [];

  Future getHistoryData() async {
    var data = await historyDb.getQuery();
    setState(() {
      listdata = data;
    });
  }

  Future onFresh() async {
    setState(() {});
    await getHistoryData();
  }

  void confirmHistoryDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Meri Cart'),
        content: Text('Clear purchase history??'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
            color: Color(0xffac7ffc),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              historyDb
                  .deleteData()
                  .then((value) => {print('Data cleared Successfully')});

              setState(() {
                listdata.clear();
              });
            },
            child: Text('Yes'),
            color: Color(0xffac7ffc),
          ),
        ],
      ),
    );
  }

  Widget NoHistoryView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.history,
            color: Color(0xffac7ffc),
            size: 50.0,
          ),
          Text(
            'No History!!',
            style: TextStyle(
              fontFamily: 'Signatra',
              letterSpacing: 1.5,
              fontSize: 50.0,
              color: Color(0xffac7ffc),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onFresh,
      child: Scaffold(
        appBar: AppBar(
          title: Text('List History'),
          actions: <Widget>[
            Visibility(
              visible: listdata.isEmpty?false:true,
              child: IconButton(
                icon: Icon(Icons.clear),
                iconSize: 20.0,
                onPressed: () {
                  confirmHistoryDelete();
                },
              ),
            )
          ],
        ),
        body: listdata.isEmpty?NoHistoryView():ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                color: Color(0xff93b2fe),
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          listdata[index].productName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 17.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: RichText(
                          text: TextSpan(children: <TextSpan>[
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
                          ]),
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
                      Text(
                        'Dated:-  ${listdata[index].dtInfo}',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: listdata.length,
          shrinkWrap: true,
        ),
      ),
    );
  }
}

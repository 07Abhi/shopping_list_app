import 'package:shoppinglistapp/dbmanager/itemsdbmanager.dart';

import 'screens/historypage.dart';
import 'package:provider/provider.dart';
import 'package:shoppinglistapp/screens/itemform.dart';
import 'package:shoppinglistapp/providerpackage/itemprovider.dart';
import 'screens/splashpage.dart';
import 'screens/cartpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ItemManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => Dbmanager(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Ubuntu',
          primaryColor: Color(0xfff595b8),
        ),
        initialRoute: SplashPage.id,
        routes: {
          CartPage.id: (context) => CartPage(),
          ItemFormPage.id: (context) => ItemFormPage(),
          HistoryPage.id: (context) => HistoryPage(),
          SplashPage.id: (context) => SplashPage(),
        },
      ),
    );
  }
}

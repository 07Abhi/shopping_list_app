import 'package:flutter/material.dart';
import 'package:shoppinglistapp/screens/cartpage.dart';

class SplashPage extends StatefulWidget {
  static final String id = 'splashPage';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
   super.initState();
   Future.delayed(Duration(seconds: 2,milliseconds: 500),(){
     Navigator.pushReplacementNamed(context, CartPage.id);
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xfff595b8),
              Color(0xffac7ffc),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/mericartlogo.png',
                height: 150.0,
                width: 150.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Meri Cart',
                  style: TextStyle(
                    fontSize: 70.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontFamily: 'Signatra'
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/home.page.dart';
import 'screens/login.screen.dart';
import 'screens/menu_cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant POS app',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/*
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant POS app'),
      ),
      body: Center(
        child: Text(''),
      ),
    );
  }
}
*/

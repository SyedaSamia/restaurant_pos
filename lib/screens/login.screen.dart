import 'package:flutter/material.dart';
import 'home.page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 100),
        constraints: BoxConstraints(
          maxHeight: 700,
          maxWidth: 400,
          minHeight: 100,
          minWidth: 100,
        ),
        alignment: Alignment.center,
        color: Colors.amber,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Login',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email Address")),
            TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: "Password")),
            RaisedButton(
                child: Text("LOGIN"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                }),
          ],
        ),
      ),
    );
  }
}

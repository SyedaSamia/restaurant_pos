import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/auth.dart';


enum AuthMode { Login }

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({
    Key key,
  }) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  final _back = Colors.blue;
  final _front = Colors.white;

  /*final _back = Colors.white;
  final _front = Colors.blue;*/

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: _back)),
        hintText: hint,
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: _back)),
        hintStyle: TextStyle(color: _back),
        errorStyle: TextStyle(color: _back),
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: _back)),
        focusedErrorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: _back)));
  }

  @override
  Widget build(BuildContext context) {
//    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: _back,
        //    padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 240, bottom: 20),
              child: Text(
                'Haal Khata - PoS App',
                style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold, color: _front),
              ),
            ),
            Container(
              //   margin: EdgeInsets.only(top: 200, bottom: 100),
              width: double.infinity,
              // padding: EdgeInsets.all(10),
              constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.Login ? 230 : 320),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 8.0,
                color: _front,
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            cursorColor: _back,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _buildInputDecoration('Email'),
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Invalid email!';
                              }
                            },
                            onSaved: (value) {
                              _authData['email'] = value;
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: _buildInputDecoration('Password'),
                            controller: _passwordController,
                            validator: (value) {
                              if (value.isEmpty || value.length < 5) {
                                return 'Password is too short!';
                              }
                            },
                            onSaved: (value) {
                              _authData['password'] = value;
                            },
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          if (_isLoading)
                            CircularProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                            )
                          else
                            AnimatedButton(
                              color: _back,
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: _submit,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(30),
                              // ),
                              // padding: EdgeInsets.symmetric(
                              //   horizontal: 30.0, vertical: 8.0),
                              //textColor: _front,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: _back,
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text("Powered by CodePura Pvt Ltd.",
                style: TextStyle(
                  //  fontFamily: 'SourceSansPro',
                  //color: Color(0xff606060),
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  // fontStyle: FontStyle.normal,
                )),
          ),
        ),
      ),
    );
  }
}

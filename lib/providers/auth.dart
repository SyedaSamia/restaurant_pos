import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import 'package:dio/dio.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  String _firstName;
  String _lastName;
  String _email;

  bool get isAuth {
    return token != null;
  }

  String get userFirstName {
    return _firstName;
  }

  String get userLastName {
    return _lastName;
  }

  String get userEmail {
    return _email;
  }

  String get userId {
    return _userId;
  }

/*
  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }
  */
  String get token {
    if (_token != null)
      return _token;
    else
      return null;
  }

  //setting token and expiry date
  Future<void> _authenticate(String email, String password) async {
    final url = 'http://haalkhata.xyz/api/user_login/';
    try {
      Dio dio = new Dio();
      //Instance level
      dio.options.contentType = Headers.formUrlEncodedContentType;
      final response = await dio.post(url,
          data: {"email": email, "password": password},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      print('>> done ${response.toString()}');

      final extractedData = response.data['response'];

      if (response != null) {
        _token = extractedData['user_id'];
        print(_token);
        _userId = extractedData['user_id'];
        _firstName = extractedData['first_name'];
        _lastName = extractedData['last_name'];
        _email = extractedData['email'];
      }

      /*_expiryDate = DateTime.now().add(
        Duration(seconds: 300),
      );
      _autoLogout();*/

      final prefs = await SharedPreferences
          .getInstance(); //this returns a future which will return a shared preference instance

      final userData = json.encode({
        'token': extractedData['user_id'],
        // 'expiryDate': _expiryDate.toIso8601String(),
        'password': password,
        'first_name': extractedData['first_name'],
        'last_name': extractedData['last_name'],
        'email': extractedData['email']
      });

      prefs.setString(
          'userData', userData); //write to shared preference device storage

      notifyListeners();
    } catch (e) {
      print(e);
      print("stops here");
    }
  }

  Future<bool> tryAutoLogin() async {
    print('>> try auto login');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('>> try autologin false');
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    /*final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }*/
    _token = extractedUserData['token'];
    _firstName = extractedUserData['first_name'];
    _lastName = extractedUserData['last_name'];
    _email = extractedUserData['email'];
    _userId = _token;
    // _expiryDate = expiryDate;
    notifyListeners();
    //_autoLogout();
    return true;
  }

  Future<void> login(String email, String password) async {
    print('>> login');
    return _authenticate(email, password);
  }

  Future<void> logout() async {
    _token = null;
    //  _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  /*void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }*/
}

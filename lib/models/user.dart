import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  User({
    @required this.userId,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    this.status,
    this.createdAt,
  });

  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String status;
  final DateTime createdAt;
}

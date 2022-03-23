import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shopify/utils/constants.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _logoutTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }

    return null;
  }

  String? get userId {
    return _userId;
  }

  void setCredential(String token, String userId, String expiryTimeInSec) {
    int expiryDateInSeconds = int.parse(expiryTimeInSec);

    _token = token;
    _userId = userId;
    _expiryDate = DateTime.now().add(Duration(seconds: expiryDateInSeconds));
    _autoLogout();

    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    final response = await Dio()
        .post(SIGNUP_URI, data: {'email': email, 'password': password});

    setCredential(response.data['idToken'], response.data['localId'],
        response.data['expiresIn']);
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await Dio().post(SIGNIN_URI, data: {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });

      setCredential(response.data['idToken'], response.data['localId'], response.data['expiresIn']);
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  void logout() {
    _token = null;
    _expiryDate = null;
    _userId = null;

    if(_logoutTimer != null) {
      _logoutTimer!.cancel();
      _logoutTimer = null;
    }

    notifyListeners();
  }

  void _autoLogout() {
    if(_logoutTimer != null) {
      _logoutTimer!.cancel();
    }

    if(_expiryDate == null) return;

    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;

    _logoutTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shopify/utils/constants.dart';


class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? userId;

  Future<void> signUp(String email, String password) async {
    final response = await Dio().post(SIGNUP_URI, data: {'email': email, 'password': password});
    print(response.data);
  }

  Future<void> signIn(String email, String password) async {
    final response = await Dio().post(SIGNIN_URI, data: {'email': email, 'password': password});
    print(response.data);
  }
}
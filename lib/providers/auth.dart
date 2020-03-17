import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryTime;
  String _userId;
  String password;
  Timer timer;

  bool get isAuth {
    return (token != null);
  }

  String get userId {
    if (_userId != null) {
      return (_userId);
    }
    return null;
  }

  String get token {
    if (_expiryTime != null &&
        _token != null &&
        _expiryTime.isAfter(DateTime.now())) {
      return (_token);
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    return authenticateUser(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return authenticateUser(email, password, 'signInWithPassword');
  }

  Future<void> authenticateUser(
      String email, String password, String authType) async {
    const token = "AIzaSyCOuDiM7qTEhkV0V9Um_YN3UQESi-yBNMs";
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$authType?key=$token';
    try {
      final response = await http.post(url, body: {
        "email": email,
        "password": password,
        "returnSecureToken": "true",
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey("error")) {
        print(responseData["error"]["message"]);
        throw Exception(responseData["error"]);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData["expiresIn"]),
        ),
      );
      autoLogout();
      await storeUserLoginData(
          userId: _userId, expiryTime: _expiryTime, token: _token);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  void logout() async {
    if (timer != null) {
      timer.cancel();
    }
    this._token = null;
    this._userId = null;
    this._expiryTime = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void autoLogout() {
    if (timer != null) {
      timer.cancel();
    }
//    int timeToExpiry = (_expiryTime.difference(DateTime.now())).inSeconds; // returns positive if expiryTime is greater than now else negative
    int timeToExpiry =
        ((DateTime.now().difference(_expiryTime)).inSeconds).abs();
//    print(timeToExpiry);
    timer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> storeUserLoginData(
      {String userId, String token, DateTime expiryTime}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userLoginData = json.encode(
      {
        "userId": userId,
        "token": token,
        "expiryTime": expiryTime.toIso8601String(),
      },
    );
    prefs.setString("userLoginData", userLoginData);
  }

  Future<Map<String, dynamic>> getStoredUserLoginData({String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      final values = prefs.get(key);
      return json.decode(values);
    }
    return {};
  }

  Future<bool> tryAutoLogin() async {
    final loginData = await getStoredUserLoginData(key: "userLoginData");
    if (loginData.isNotEmpty) {
      _token = loginData["token"];
      _userId = loginData["userId"];
      _expiryTime = DateTime.parse(loginData["expiryTime"]);
      notifyListeners();
      autoLogout();
      return true;
    }
    return false;
  }
}

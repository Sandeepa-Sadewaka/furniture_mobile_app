import 'package:flutter/material.dart';

class Authprovider with ChangeNotifier{
  bool _isLoggedIn = false;
  String _loginmail = 'ss';

  bool get isLoggedIn => _isLoggedIn;
  void login(){
    _isLoggedIn = true;
    notifyListeners();
  }
  void logout(){
    _isLoggedIn = false;
    notifyListeners();
  }
  String setMail(String mail){
    _loginmail = mail;
    notifyListeners();
    return _loginmail;
  }
  String getMail(){
    return _loginmail;
  }

}
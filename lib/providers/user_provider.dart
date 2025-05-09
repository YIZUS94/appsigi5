import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _userRole;

  String? get userRole => _userRole;

  Future<void> setUserRole(String? role) async {
    _userRole = role;
    notifyListeners();
  }

  Future<void> clearUserRole() async {
    _userRole = null;
    notifyListeners();
  }
}
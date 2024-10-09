import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier{
  String? _name;
  String? _email;
  String? _phone;
  String? _photo;

  // Getters for user data
  String? get name => _name;
  String? get email => _email;
  String? get phone => _phone;
  String? get photo => _photo;

  // Load user data from SharedPreferences
   Future<void> loadUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _name = sharedPreferences.getString('name') ?? '';
    _email = sharedPreferences.getString('email') ?? '';
    _phone = sharedPreferences.getString('phone') ?? '';
    _photo = sharedPreferences.getString('photo') ?? '';

    // Notify listeners of changes
    notifyListeners();
  }

}



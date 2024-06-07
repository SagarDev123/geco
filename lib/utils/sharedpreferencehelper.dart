import 'dart:convert';

import 'package:geco/data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static Future<void> saveContent(User content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = jsonEncode(content.toJson());
    prefs.setString('userData', user);
  }

  static Future<User?> getContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    if (userData != null) {
      Map<String, dynamic> json = jsonDecode(userData);
      return User.fromJson(json);
    }
    return null;
  }

  static getToken() {}
}

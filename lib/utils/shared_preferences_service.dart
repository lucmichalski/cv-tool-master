import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();
  //
  // static const String taiKhoan = 'taiKhoan';
  // static const String ten = 'ten';
  // static const String email = 'email';
  static const String token = 'token';
 // static const String password = 'password';
}

class SharedPreferencesService {
  static SharedPreferencesService _instance;
  static SharedPreferences _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  // Save accessToken
  Future<void> saveAccessToken(String accessToken) async =>
      await _preferences.setString(SharedPrefKeys.token, accessToken);

  // Remove accessToken when logout
  Future<void> removeAccessToken() async =>
      await _preferences.remove(SharedPrefKeys.token);

  // Get accessToken
  String get getAccessToken =>
      _preferences.getString(SharedPrefKeys.token) ?? kEmpty;

  // Get accessToken
  static String get getToken =>
      _preferences.getString(SharedPrefKeys.token) ?? kEmpty;

}

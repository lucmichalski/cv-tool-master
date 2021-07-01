import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();
  //
  // static const String taiKhoan = 'taiKhoan';
  static const String fullNm = 'fullNm';
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

  // Remove User name when logout
  Future<void> removeAccessToken() async =>
      await _preferences.remove(SharedPrefKeys.token);

  // Save userName
  Future<void> saveUserNm(String userNm) async =>
      await _preferences.setString(SharedPrefKeys.fullNm, userNm);

  // Remove User name when logout
  Future<void> removeUserNm() async =>
      await _preferences.remove(SharedPrefKeys.fullNm);

  // Get accessToken
  String get getAccessToken =>
      _preferences.getString(SharedPrefKeys.token) ?? kEmpty;

  // Get username
  String get getUserNm =>
      _preferences.getString(SharedPrefKeys.fullNm) ?? kEmpty;

  // Get accessToken
  static String get getToken =>
      _preferences.getString(SharedPrefKeys.token) ?? kEmpty;

}

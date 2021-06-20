import 'dart:convert';

import 'package:flutter_cv_maker/models/auth/login_response.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/services/api_constants.dart';
import 'package:http/http.dart' as http;

class Repository {
  getHeader(String accessToken) {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': accessToken
    };
  }

  // SignIn api call
  Future<LoginResponse> signIn(String username, String password) async {
    Map data = {"email": username, "password": password};
    // Update lai url theo du an moi
    final response = await http.post(Uri.tryParse(BaseUrl + LoginURL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }

  // Request add master data
  Future<MasterData> addMasterData(
      String accessToken, String requestBody) async {
    final response = await http.post(
        Uri.tryParse(BaseUrl + RequestAddMasterUrl),
        headers: getHeader(accessToken),
        body: requestBody);
    if (response.statusCode == 200) {
      return MasterData.fromJson(json.decode(response.body));
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }
}

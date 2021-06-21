import 'dart:convert';

import 'package:flutter_cv_maker/models/auth/login_response.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
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
  Future<MasterData> addMasterData(String accessToken, String requestBody) async {
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

  // Request add master data
  Future<MasterData> updateMasterData(String accessToken, String requestBody) async {
    final response = await http.put(
        Uri.tryParse(BaseUrl + RequestUpdateMasterUrl),
        headers: getHeader(accessToken),
        body: requestBody);
    if (response.statusCode == 200) {
      return MasterData.fromJson(json.decode(response.body));
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }

  Future<MasterData> fetchMasterData(String accessToken) async {
    final response = await http.get(Uri.parse(BaseUrl + RequestGetMasterUrl),
      headers: getHeader(accessToken)
    );
    if (response.statusCode == 200) {
      return MasterData.fromJson(jsonDecode(response.body));
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }
  // create cv
  Future<CVModel> createCv(String accessToken, String requestBody) async {
    final response = await http.post(
        Uri.tryParse(BaseUrl + RequestCreateCvUrl),
        headers: getHeader(accessToken),
        body: requestBody);
    if (response.statusCode == 200) {
      return CVModel.fromJson(json.decode(response.body));
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }
  // get cv
  Future<List<CVModel>> fetchDataCV(String accessToken) async {
    final response = await http.get(Uri.parse(BaseUrl + RequestGetCvUrl),
        headers: getHeader(accessToken)
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => CVModel.fromJson(model)).toList();
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }
}

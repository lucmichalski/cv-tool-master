import 'dart:convert';

import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/auth/login_response.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model_response.dart';
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
  Future<String> addMasterData(String accessToken, String requestBody) async {
    print('Add MasterData: $requestBody');
    final response = await http.post(
        Uri.tryParse(BaseUrl + RequestAddMasterUrl),
        headers: getHeader(accessToken),
        body: requestBody);
    if (response.statusCode == 200) {
      var message = json.decode(response.body)["success"];
      return message;
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }

  // Request add master data
  Future<String> updateMasterData(String accessToken, String requestBody) async {
    final response = await http.post(
        Uri.tryParse(BaseUrl + RequestUpdateMasterUrl),
        headers: getHeader(accessToken),
        body: requestBody);
    print('UPDATE -- ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      var message = json.decode(response.body)["success"];
      return message;
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
      if (response.body.toString() == '{}') return null;
      return MasterData.fromJson(jsonDecode(response.body));
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }
  // create cv
  Future<String> createCv(String accessToken, String requestBody) async {
    final response = await http.post(
        Uri.tryParse(BaseUrl + RequestCreateCvUrl),
        headers: getHeader(accessToken),
        body: requestBody);
    if (response.statusCode == 200) {
      return json.decode(response.body)["_id"];
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }
  // get cv
  Future<ListCVResponse> fetchDataCV(String accessToken, int pageIndex, bool status, bool createdDate) async {
    print('URL GET CV: ${BaseUrl + RequestGetCvUrl + '/$pageIndex' +'?status=$status' + '&createddate=$createdDate'}');
    final response = await http.get(Uri.parse(BaseUrl + RequestGetCvUrl + '/$pageIndex' +'?status=${status ?? kEmpty}' + '&createddate=${createdDate ?? kEmpty}'),
        headers: getHeader(accessToken)
    );
    if (response.statusCode == 200) {
      return ListCVResponse.fromJson(json.decode(response.body));
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }
  // update cv
  Future<CVModel> updateCv(String accessToken, String requestBody,String id) async {
    final response = await http.put(
        Uri.tryParse(BaseUrl + RequestUpdateCvUrl + '/$id'),
        headers: getHeader(accessToken),
        body: requestBody);
    print('Request Body UpdateCV: $requestBody');
    if (response.statusCode == 200) {
      print('StatusCd: ${response.statusCode} -- URl: ${BaseUrl + RequestUpdateCvUrl + '/$id'}');
      return CVModel.fromJson(json.decode(response.body));
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }

  // delete data cv
  Future<bool> requestDeleteCv(String accessToken, String id) async {
    final response = await http.delete(
      Uri.tryParse(BaseUrl + RequestUpdateCvUrl + '/$id'),
      headers: getHeader(accessToken),
    );
    if (response.statusCode == 200) {
      print('URl:${BaseUrl + RequestCreateCvUrl + '/$id'}');
      return true;
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }
  Future<String> updatePassWord(String accessToken, String requestBody) async {
    final response = await http.put(
        Uri.tryParse(BaseUrl + RequestChangePasswordUrl),
        headers: getHeader(accessToken),
        body: requestBody);
    print('UPDATE -- ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body)["success"];
    } else {
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }
  //
  Future<List<DataPosition>> fetchTotalPosition(String accessToken) async {
    final response = await http.get(Uri.parse(BaseUrl + RequestTotalPositionUrl),
        headers: getHeader(accessToken)
    );
    print(accessToken);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DataPosition.fromJson(model)).toList();
    } else {
      print('sdfd');
      var message = json.decode(response.body)["message"];
      throw Exception('$message');
    }
  }
}

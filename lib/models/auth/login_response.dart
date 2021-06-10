class LoginResponse {
  String authToken;
  String message;
  LoginResponse({this.authToken, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      authToken: json['token'],
      message: json['message'],
    );
  }
}

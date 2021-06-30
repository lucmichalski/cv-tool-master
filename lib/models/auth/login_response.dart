class LoginResponse {
  String token;
  String refreshToken;
   String  fullName;
  LoginResponse({this.token, this.refreshToken,this.fullName});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
    fullName = json['fullname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    data['fullname'] = this.fullName;
    return data;
  }
}
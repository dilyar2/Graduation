class LoginResponseModel {
  String? token;
  int? expiresInMinutes;
  String? refreshToken;

  LoginResponseModel({this.token, this.expiresInMinutes, this.refreshToken});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiresInMinutes = json['expiresInMinutes'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['expiresInMinutes'] = expiresInMinutes;
    data['refreshToken'] = refreshToken;
    return data;
  }
}

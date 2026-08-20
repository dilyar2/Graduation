class RegisterRequestModel {
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  String? phoneNumber;

  RegisterRequestModel(
      {this.email,
      this.firstName,
      this.lastName,
      this.password,
      this.phoneNumber});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['password'] = password;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}

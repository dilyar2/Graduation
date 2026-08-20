class ProfileModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  int? role;
  String? imageUrl;

  ProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.role,
    this.imageUrl,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    role = json['role'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'imageUrl': imageUrl,
    };
  }
}

class TeacherModel {
  int? userId;
  String? firstName;
  String? lastName;
  String? bio;
  String? specialization;
  double? averageRating;
  int? viewCount;

  TeacherModel(
      {this.userId,
      this.firstName,
      this.lastName,
      this.bio,
      this.specialization,
      this.averageRating,
      this.viewCount});

  TeacherModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    bio = json['bio'];
    specialization = json['specialization'];
    averageRating = json['averageRating'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['bio'] = bio;
    data['specialization'] = specialization;
    data['averageRating'] = averageRating;
    data['viewCount'] = viewCount;
    return data;
  }
}

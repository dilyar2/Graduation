class EnrollModel {
  int? enrollmentId;
  int? courseId;
  int? paymentId;
  double? amount;
  String? status;

  EnrollModel(
      {this.enrollmentId,
      this.courseId,
      this.paymentId,
      this.amount,
      this.status});

  EnrollModel.fromJson(Map<String, dynamic> json) {
    enrollmentId = (json['enrollmentId'] as num?)?.toInt();
    courseId = (json['courseId'] as num?)?.toInt();
    paymentId = (json['paymentId'] as num?)?.toInt();
    amount = (json['amount'] as num?)?.toDouble();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enrollmentId'] = enrollmentId;
    data['courseId'] = courseId;
    data['paymentId'] = paymentId;
    data['amount'] = amount;
    data['status'] = status;
    return data;
  }
}

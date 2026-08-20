class PaymentModel {
  final int? enrollmentId;
  final int? courseId;
  final int? paymentId;
  final double? amount;
  final String? status;

  const PaymentModel({
    this.enrollmentId,
    this.courseId,
    this.paymentId,
    this.amount,
    this.status,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      enrollmentId: (json['enrollmentId'] as num?)?.toInt(),
      courseId: (json['courseId'] as num?)?.toInt(),
      paymentId: (json['paymentId'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      status: json['status'],
    );
  }

  bool get isSuccess {
    final value = status?.trim().toLowerCase() ?? '';
    return value == 'success' ||
        value == 'paid' ||
        value == 'completed' ||
        value == 'complete';
  }
}

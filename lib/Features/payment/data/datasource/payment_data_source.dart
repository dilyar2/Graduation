import 'package:graduation2/Features/payment/data/models/payment_model.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:injectable/injectable.dart';

@injectable
class PaymentDataSource {
  final DioClient dioClient;

  PaymentDataSource({required this.dioClient});

  Future<PaymentModel> payEnrollment({required int enrollmentId}) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.pay,
      data: {'enrollmentId': enrollmentId},
    );
    return PaymentModel.fromJson(response.data);
  }
}

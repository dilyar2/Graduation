import 'package:graduation2/Features/enroll/data/models/enroll_model.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:injectable/injectable.dart';

@injectable
class EnrollDataSource {
  final DioClient dioClient;

  EnrollDataSource({required this.dioClient});

  Future<EnrollModel> enrollCourse({required int courseId}) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.enroll,
      data: {"courseId": courseId},
    );
    return EnrollModel.fromJson(response.data);
  }
}

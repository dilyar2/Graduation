import 'package:dio/dio.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class QuizDataSource {
  final DioClient dioClient;

  QuizDataSource({
    required this.dioClient,
  });

  Future<Map<String, dynamic>> getSectionQuiz({
    required int courseId,
    required int sectionId,
  }) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.courseQuiz(
        courseId: courseId,
        sectionId: sectionId,
      ),
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    if (data is List) {
      return <String, dynamic>{'items': data};
    }

    throw const FormatException('Invalid quiz response format');
  }




  Future<void> submitTest({
    required int testId,
    required MultipartFile file,
  }) async {
    await dioClient.dio.post(
      ApiEndpoints.submitTest,
      data: FormData.fromMap({
        'testId': testId,
        'file': file,
      }),
    );
  }
}

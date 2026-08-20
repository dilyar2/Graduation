import 'package:graduation2/Features/courses_enrollment/data/models/courses_enrollment_model.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:injectable/injectable.dart';

@injectable
class CourseEnrollmentDataSource {
  final DioClient dioClient;

  CourseEnrollmentDataSource({required this.dioClient});
  Future<CoursesEnrollmentModel> getEnrolledCourses({
    required bool unpaidOnly,
  }) async {
    final result = await dioClient.dio.get(
      ApiEndpoints.myCourses,
      queryParameters: {'unpaidOnly': unpaidOnly},
    );
    return CoursesEnrollmentModel.fromJson(result.data);
  }
}

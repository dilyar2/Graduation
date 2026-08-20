import 'package:graduation2/Features/sections/data/models/section_model.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:injectable/injectable.dart';
@injectable
class SectionDataSource {
  final DioClient dioClient;

  SectionDataSource({required this.dioClient});
  Future<SectionModel> getSectionsToSpecificCourse({
    required int courseId,
  }) async {
    final response = await dioClient.dio.get(ApiEndpoints.courseInfo(courseId));
    return SectionModel.fromJson(response.data);
  }
}

import 'package:flutter/foundation.dart';
import 'package:graduation2/Features/course_info/data/models/course_info_model.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:injectable/injectable.dart';
@injectable

class CourseInfoDataSource {
  final DioClient dioClient;

  CourseInfoDataSource({required this.dioClient});
  Future<CourseInfoModel> getCourseInfo({required int id}) async {
    final response = await dioClient.dio.get(ApiEndpoints.courseInfo(id));
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['course'] ?? data['result'];
      if (nested is Map) {
        return CourseInfoModel.fromJson(Map<String, dynamic>.from(nested));
      }
      return CourseInfoModel.fromJson(data);
    }
    throw const FormatException('Invalid course info response');
  }
}

import 'package:flutter/material.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class CourseRemoteDataSource {
  final DioClient dioClient;

  CourseRemoteDataSource({required this.dioClient});







  Future<CoursesByCategoryModel> getCoursesByCategory({
    required String category,
    String? search,
    String? tags,
    int page = 1,
    int pageSize = 10,
    String? orderBy,
    String direction = 'desc',
  }) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.courses,
      queryParameters: {
        'categories': category,
        if (search != null && search.isNotEmpty) 'search': search,
        if (tags != null && tags.isNotEmpty) 'tags': tags,
        'page': page,
        'pageSize': pageSize,
        if (orderBy != null && orderBy.isNotEmpty) 'orderBy': orderBy,
        'direction': direction,
      },
    );

    assert(() {

      return true;
    }());

    return CoursesByCategoryModel.fromApiResponse(response.data);
  }

  Future<CoursesByCategoryModel> getAllCourses({
    int? teacherId,
    String? search,
    String? tags,
    int page = 1,
    int pageSize = 10,
    String? orderBy,
    String direction = 'desc',
  }) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.courses,
      queryParameters: {
        if (teacherId != null) 'teacherId': teacherId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (tags != null && tags.isNotEmpty) 'tags': tags,
        'page': page,
        'pageSize': pageSize,
        if (orderBy != null && orderBy.isNotEmpty) 'orderBy': orderBy,
        'direction': direction,
      },
    );


    return CoursesByCategoryModel.fromApiResponse(response.data);
  }
}

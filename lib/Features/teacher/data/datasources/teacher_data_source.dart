import 'package:dio/dio.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/Features/teacher/data/models/teacher_model.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class TeacherDataSource {
  final DioClient dioClient;

  TeacherDataSource({required this.dioClient});

  Future<List<TeacherModel>> getAllTeachers({String? orderBy}) async {
    DioException? directError;


    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.teachers,
        queryParameters: {if (orderBy != null) 'orderBy': orderBy},
      );

      final result = _normalizeList(response.data);
      if (result.isNotEmpty) return result;
    } on DioException catch (e) {
      directError = e;
    }




    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.courses,
        queryParameters: {
          'page': 1,
          'pageSize': 100,
        },
      );

      final courses = CoursesByCategoryModel.fromApiResponse(response.data);
      final teacherIds = <int>{
        for (final course in courses.items)
          if (course.teacherId != null) course.teacherId!,
      };

      final teachers = <TeacherModel>[];

      for (final id in teacherIds.take(20)) {
        try {
          final teacherResponse = await dioClient.dio.get(
            ApiEndpoints.teacher(id),
          );
          final teacher = _normalizeTeacher(teacherResponse.data);
          if (teacher != null) teachers.add(teacher);
        } on DioException {

        }
      }

      return teachers;
    } catch (_) {
      if (directError != null) throw directError;
      rethrow;
    }
  }

  List<TeacherModel> _normalizeList(dynamic value) {
    final list = <dynamic>[];

    if (value is List) {
      list.addAll(value);
    } else if (value is Map) {
      final normalized = value['items'] ?? value['data'] ?? value['teachers'];
      if (normalized is List) {
        list.addAll(normalized);
      } else if (value['userId'] != null || value['firstName'] != null) {
        list.add(value);
      }
    }

    return list
        .whereType<Map>()
        .map((teacher) => TeacherModel.fromJson(
              Map<String, dynamic>.from(teacher),
            ))
        .where((teacher) => teacher.userId != null)
        .toList();
  }

  TeacherModel? _normalizeTeacher(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      final nested = map['data'] ?? map['teacher'];
      if (nested is Map) {
        return TeacherModel.fromJson(Map<String, dynamic>.from(nested));
      }
      if (map['userId'] != null || map['firstName'] != null) {
        return TeacherModel.fromJson(map);
      }
    }
    return null;
  }
}

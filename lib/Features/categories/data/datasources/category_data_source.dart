import 'package:dio/dio.dart';
import 'package:graduation2/Features/categories/data/models/category_model.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryDataSource {
  final DioClient dioClient;

  CategoryDataSource({required this.dioClient});

  Future<List<CategoryModel>> getAllcategories() async {
    DioException? directError;



    try {
      final response = await dioClient.dio.get(ApiEndpoints.courseCategories);
      final result = _normalizeCategories(response.data);
      if (result.isNotEmpty) {
        return result;
      }
    } on DioException catch (e) {
      directError = e;
    }





    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.courses,
        queryParameters: {'page': 1, 'pageSize': 100},
      );

      final courses = CoursesByCategoryModel.fromApiResponse(response.data);
      final names = <String>{};

      for (final course in courses.items) {
        for (final category in course.categories) {
          final name = category.trim();
          if (name.isNotEmpty) names.add(name);
        }
      }

      return names.map((name) => CategoryModel(name: name)).toList();
    } catch (_) {
      if (directError != null) throw directError;
      rethrow;
    }
  }

  List<CategoryModel> _normalizeCategories(dynamic value) {
    final list = <dynamic>[];

    if (value is List) {
      list.addAll(value);
    } else if (value is Map) {
      final normalized = value['items'] ?? value['data'] ?? value['categories'];
      if (normalized is List) {
        list.addAll(normalized);
      }




    }

    return list
        .whereType<Map>()
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
        .where((category) => category.name?.trim().isNotEmpty == true)
        .toList();
  }
}

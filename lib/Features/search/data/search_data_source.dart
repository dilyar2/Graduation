import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/Features/search/data/models/search_suggestions_model.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchRemoteDataSource {
  final DioClient dioClient;

  SearchRemoteDataSource(this.dioClient);

  Future<CoursesByCategoryModel> searchCourses({
    String? search,
    String? tags,
    String? categories,
    int? teacherId,
    int page = 1,
    int pageSize = 10,
    String? orderBy,
    String direction = 'desc',
  }) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.courses,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (tags != null && tags.isNotEmpty) 'tags': tags,
        if (categories != null && categories.isNotEmpty)
          'categories': categories,
        if (teacherId != null) 'teacherId': teacherId,
        'page': page,
        'pageSize': pageSize,
        if (orderBy != null && orderBy.isNotEmpty) 'orderBy': orderBy,
        'direction': direction,
      },
    );

    return CoursesByCategoryModel.fromJson(response.data);
  }

  Future<SearchSuggestionsModel> getSearchSuggestions({
    int limit = 10,
    int? days,
  }) async {
    final responses = await Future.wait([
      dioClient.dio.get(
        ApiEndpoints.mySearches,
        queryParameters: {'limit': limit},
      ),
      dioClient.dio.get(
        ApiEndpoints.mostUsedSearches,
        queryParameters: {
          'limit': limit,
          if (days != null) 'days': days,
        },
      ),
    ]);

    return SearchSuggestionsModel(
      recent: _parseSuggestions(responses[0].data),
      mostUsed: _parseSuggestions(responses[1].data),
    );
  }




  List<String> _parseSuggestions(dynamic data) {
    dynamic payload = data;

    if (payload is Map) {
      payload = payload['items'] ??
          payload['data'] ??
          payload['results'] ??
          payload['searches'] ??
          payload['queries'] ??
          payload['values'] ??
          payload;
    }

    if (payload is! List) {
      if (payload is String && payload.trim().isNotEmpty) {
        return [payload.trim()];
      }
      return const [];
    }

    final result = <String>[];

    for (final item in payload) {
      String? value;

      if (item is String) {
        value = item;
      } else if (item is Map) {
        for (final key in const [
          'search',
          'query',
          'term',
          'keyword',
          'text',
          'name',
          'value',
        ]) {
          final candidate = item[key];
          if (candidate is String && candidate.trim().isNotEmpty) {
            value = candidate;
            break;
          }
        }
      }

      final normalized = value?.trim();
      if (normalized != null &&
          normalized.isNotEmpty &&
          !result.contains(normalized)) {
        result.add(normalized);
      }
    }

    return result;
  }
}

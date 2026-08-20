import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/Features/search/data/models/search_suggestions_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class SearchRepo {
  Future<Either<Failure, CoursesByCategoryModel>> searchCourses({
    String? search,
    String? tags,
    String? categories,
    int? teacherId,
    int page = 1,
    int pageSize = 10,
    String? orderBy,
    String direction = 'desc',
  });

  Future<Either<Failure, SearchSuggestionsModel>> getSearchSuggestions({
    int limit = 10,
    int? days,
  });
}

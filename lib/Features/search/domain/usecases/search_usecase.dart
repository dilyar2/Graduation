import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/Features/search/data/models/search_suggestions_model.dart';
import 'package:graduation2/Features/search/domain/repo/search_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchCoursesUseCase {
  final SearchRepo repository;

  SearchCoursesUseCase(this.repository);

  Future<Either<Failure, CoursesByCategoryModel>> call({
    String? search,
    String? tags,
    String? categories,
    int? teacherId,
    int page = 1,
    int pageSize = 10,
    String? orderBy,
    String direction = 'desc',
  }) {
    return repository.searchCourses(
      search: search,
      tags: tags,
      categories: categories,
      teacherId: teacherId,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      direction: direction,
    );
  }

  Future<Either<Failure, SearchSuggestionsModel>> getSearchSuggestions({
    int limit = 10,
    int? days,
  }) {
    return repository.getSearchSuggestions(
      limit: limit,
      days: days,
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/Features/courses/domain/repositories/courses_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCoursesByCategoryUseCase {
  final CoursesRepo repository;

  GetCoursesByCategoryUseCase({required this.repository});

  Future<Either<Failure, CoursesByCategoryModel>> call({
    required String category,
    String? search,
    String? tags,
    int page = 1,
    int pageSize = 10,
    String? orderBy,
    String direction = 'desc',
  }) {
    return repository.getCoursesByCategoryRepo(
      category: category,
      search: search,
      tags: tags,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      direction: direction,
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class CoursesRepo {
  Future<Either<Failure, CoursesByCategoryModel>> getCoursesByCategoryRepo({
    required String category,
    String? search,
    String? tags,
    int page,
    int pageSize,
    String? orderBy,
    String direction,
  });

  Future<Either<Failure, CoursesByCategoryModel>> getAllCoursesRepo({
    int? teacherId,
    String? search,
    String? tags,
    int page,
    int pageSize,
    String? orderBy,
    String direction,
  });
}

import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/Features/courses/domain/repositories/courses_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllCoursesToTeacherUsecases {
  final CoursesRepo coursesRepo;

  GetAllCoursesToTeacherUsecases({required this.coursesRepo});

  Future<Either<Failure, List<CourseModel>>> call({required int id}) async {
    final result = await coursesRepo.getAllCoursesRepo(
      teacherId: id,
      page: 1,
      pageSize: 20,
    );

    return result.fold(
      (failure) => Left(failure),
      (courses) => Right(courses.items),
    );
  }
}

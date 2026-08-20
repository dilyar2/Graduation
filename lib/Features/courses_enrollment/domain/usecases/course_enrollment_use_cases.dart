import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/courses_enrollment/data/models/courses_enrollment_model.dart';
import 'package:graduation2/Features/courses_enrollment/domain/repo/course_enrollment_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class CourseEnrollmentUseCases {
  final CourseEnrollmentRepo courseEnrollmentRepo;

  CourseEnrollmentUseCases({required this.courseEnrollmentRepo});
  Future<Either<Failure, CoursesEnrollmentModel>> call({required bool unpaidOnly})
  {
    return courseEnrollmentRepo.getCoursesEnrollment(unpaidOnly: unpaidOnly);
  }
}

import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/courses_enrollment/data/models/courses_enrollment_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class CourseEnrollmentRepo {
  Future<Either<Failure, CoursesEnrollmentModel>> getCoursesEnrollment({required bool unpaidOnly});

}

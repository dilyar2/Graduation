import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/courses_enrollment/data/data_source/courses_enrollment_data_source.dart';
import 'package:graduation2/Features/courses_enrollment/data/models/courses_enrollment_model.dart';
import 'package:graduation2/Features/courses_enrollment/domain/repo/course_enrollment_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CourseEnrollmentRepo)
class CoursesEnrollmentRepoImpl implements CourseEnrollmentRepo {
  final CourseEnrollmentDataSource courseEnrollmentDataSource;

  CoursesEnrollmentRepoImpl({required this.courseEnrollmentDataSource});

  @override
  Future<Either<Failure, CoursesEnrollmentModel>> getCoursesEnrollment({
    required bool unpaidOnly,
  }) async {
    try {
      final Result = await courseEnrollmentDataSource.getEnrolledCourses(
        unpaidOnly: unpaidOnly,
      );
      return Right(Result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to enroll in course'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error while enrolling: $e'));
    }
  }
}

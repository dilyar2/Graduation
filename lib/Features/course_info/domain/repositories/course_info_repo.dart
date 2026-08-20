import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/course_info/data/models/course_info_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class CourseInfoRepo {
  Future<Either<Failure, CourseInfoModel>> getCoursesInfoRepo({
    required int id,
  });
}

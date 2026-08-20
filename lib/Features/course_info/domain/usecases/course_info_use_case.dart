 import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/course_info/data/models/course_info_model.dart';
import 'package:graduation2/Features/course_info/domain/repositories/course_info_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';
@injectable

class CourseInfoUseCase {
  final CourseInfoRepo courseInfoRepo;

  CourseInfoUseCase({required this.courseInfoRepo});
Future<Either<Failure,CourseInfoModel>>call({required int id}){
  return courseInfoRepo.getCoursesInfoRepo(id: id);
}
 }

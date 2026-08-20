import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/teacher/data/models/teacher_model.dart';
import 'package:graduation2/Features/teacher/domain/repositories/teacher_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetAllTeachesUsecase {
  final TeacherRepo teacherRepo;
  GetAllTeachesUsecase({required this.teacherRepo});
  Future<Either<Failure, List<TeacherModel>>> call({String? orderBy}) async {
    return teacherRepo.getAllTeachers(order: orderBy);
  }
}

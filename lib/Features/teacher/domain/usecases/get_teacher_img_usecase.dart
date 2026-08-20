import 'dart:typed_data';

import 'package:graduation2/Features/teacher/domain/repositories/teacher_repo.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetTeacherImgUsecase {
  final TeacherRepo teacherRepo;

  GetTeacherImgUsecase({required this.teacherRepo});
  Future<Uint8List>call(int id){
    return teacherRepo.getTeachersImage(id: id);
  }

}

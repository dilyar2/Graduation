import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/teacher/data/models/teacher_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class TeacherRepo {
  Future<Either<Failure,List< TeacherModel>>> getAllTeachers({String? order});
  Future<Uint8List>getTeachersImage({required int id});
}

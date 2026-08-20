import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/teacher/data/datasources/image_teacher_data_source.dart';
import 'package:graduation2/Features/teacher/data/datasources/teacher_data_source.dart';
import 'package:graduation2/Features/teacher/data/models/teacher_model.dart';
import 'package:graduation2/Features/teacher/domain/repositories/teacher_repo.dart';
import 'package:graduation2/core/error/error_mapper.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TeacherRepo)
class TeacherRepoImpl implements TeacherRepo {
  final TeacherDataSource teacherDataSource;
  final ImageTeacherDataSource imageTeacherDataSource;

  TeacherRepoImpl(
    this.imageTeacherDataSource, {
    required this.teacherDataSource,
  });

  @override
  Future<Either<Failure, List<TeacherModel>>> getAllTeachers({
    String? order,
  }) async {
    try {
      final result = await teacherDataSource.getAllTeachers();
      return Right(result);
    } on DioException catch (e) {
      return Left(NetworkFailure(ErrorMessageMapper.fromDio(e)));
    } on Exception catch (e) {
      return Left(ServerFailure(ErrorMessageMapper.fromException(e)));
    }
  }

  @override
  Future<Uint8List> getTeachersImage({required int id}) async {
    return imageTeacherDataSource.getTeacherImage(id);
  }
}

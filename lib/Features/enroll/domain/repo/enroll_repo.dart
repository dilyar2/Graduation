import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/enroll/data/models/enroll_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class EnrollRepo {
  Future<Either<Failure, EnrollModel>> enroll({required int courseId});
}

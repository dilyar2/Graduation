import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/sections/data/models/section_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class SectionRepo {
  Future<Either<Failure,SectionModel>>getSection({required int id});
}

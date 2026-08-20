import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/sections/data/dataSources/section_data_source.dart';
import 'package:graduation2/Features/sections/data/models/section_model.dart';
import 'package:graduation2/Features/sections/domain/repositories/section_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: SectionRepo)
class SectionRepoImpl implements SectionRepo {
  final SectionDataSource sectionDataSource;

  SectionRepoImpl({required this.sectionDataSource});
  @override
  Future<Either<Failure, SectionModel>> getSection({required int id}) async {
    try {
      final result = await sectionDataSource.getSectionsToSpecificCourse(
        courseId: id,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/enroll/data/datasource/enroll_data_source.dart';
import 'package:graduation2/Features/enroll/data/models/enroll_model.dart';
import 'package:graduation2/Features/enroll/domain/repo/enroll_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EnrollRepo)
class EnrollRepoImpl implements EnrollRepo {
  final EnrollDataSource enrollDataSource;

  EnrollRepoImpl({required this.enrollDataSource});

  @override
  Future<Either<Failure, EnrollModel>> enroll({required int courseId}) async {
    try {
      final result = await enrollDataSource.enrollCourse(courseId: courseId);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to enroll in course'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error while enrolling: $e'));
    }
  }

}

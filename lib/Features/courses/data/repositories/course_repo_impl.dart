import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/courses/data/datasources/courses_data_source.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/Features/courses/domain/repositories/courses_repo.dart';
import 'package:graduation2/core/error/error_mapper.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CoursesRepo)
class CoursesRepoImpl implements CoursesRepo {
  final CourseRemoteDataSource courseRemoteDataSource;

  CoursesRepoImpl({required this.courseRemoteDataSource});

  @override
  Future<Either<Failure, CoursesByCategoryModel>> getCoursesByCategoryRepo({
    required String category,
    String? search,
    String? tags,
    int page = 1,
    int pageSize = 10,
    String? orderBy,
    String direction = 'desc',
  }) async {
    try {
      final result = await courseRemoteDataSource.getCoursesByCategory(
        category: category,
        search: search,
        tags: tags,
        page: page,
        pageSize: pageSize,
        orderBy: orderBy,
        direction: direction,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(NetworkFailure(ErrorMessageMapper.fromDio(e)));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(ErrorMessageMapper.fromException(e)));
    }
  }

  @override
  Future<Either<Failure, CoursesByCategoryModel>> getAllCoursesRepo({
    int? teacherId,
    String? search,
    String? tags,
    int page = 1,
    int pageSize = 10,
    String? orderBy,
    String direction = 'desc',
  }) async {
    try {
      final result = await courseRemoteDataSource.getAllCourses(
        teacherId: teacherId,
        search: search,
        tags: tags,
        page: page,
        pageSize: pageSize,
        orderBy: orderBy,
        direction: direction,
      );

      return Right(result);
    } on DioException catch (e) {
      return Left(NetworkFailure(ErrorMessageMapper.fromDio(e)));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(ErrorMessageMapper.fromException(e)));
    }
  }
}

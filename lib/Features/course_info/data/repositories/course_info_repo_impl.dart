import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/course_info/data/datasource/course_info_data_source.dart';
import 'package:graduation2/Features/course_info/data/models/course_info_model.dart';
import 'package:graduation2/Features/course_info/domain/repositories/course_info_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: CourseInfoRepo)
class CourseInfoRepoImpl  implements CourseInfoRepo{
  final CourseInfoDataSource courseInfoDataSource;

  CourseInfoRepoImpl({required this.courseInfoDataSource});
  @override
  Future<Either<Failure, CourseInfoModel>> getCoursesInfoRepo({required int id})async {
    try{
   final result=await courseInfoDataSource.getCourseInfo(id: id);
   return Right(result);
    }
   on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}

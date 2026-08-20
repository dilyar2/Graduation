import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/categories/data/datasources/category_data_source.dart';
import 'package:graduation2/Features/categories/data/models/category_model.dart';
import 'package:graduation2/Features/categories/domain/repositories/category_repo.dart';
import 'package:graduation2/core/error/error_mapper.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoryRepo)
class CategoryRepoImpl implements CategoryRepo {
  final CategoryDataSource categoryDataSource;

  CategoryRepoImpl({required this.categoryDataSource});

  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategory() async {
    try {
      final result = await categoryDataSource.getAllcategories();
      return Right(result);
    } on DioException catch (e) {
      return Left(NetworkFailure(ErrorMessageMapper.fromDio(e)));
    } on Exception catch (e) {
      return Left(ServerFailure(ErrorMessageMapper.fromException(e)));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/Features/search/data/models/search_suggestions_model.dart';
import 'package:graduation2/Features/search/data/search_data_source.dart';
import 'package:graduation2/Features/search/domain/repo/search_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRepo)
class SearchRepositoryImpl implements SearchRepo {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, CoursesByCategoryModel>> searchCourses({
    String? search,
    String? tags,
    String? categories,
    int? teacherId,
    int page = 1,
    int pageSize = 10,
    String? orderBy,
    String direction = 'desc',
  }) async {
    try {
      final result = await remoteDataSource.searchCourses(
        search: search,
        tags: tags,
        categories: categories,
        teacherId: teacherId,
        page: page,
        pageSize: pageSize,
        orderBy: orderBy,
        direction: direction,
      );

      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(_serverMessage(e) ?? 'Unable to search courses.'));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchSuggestionsModel>> getSearchSuggestions({
    int limit = 10,
    int? days,
  }) async {
    try {
      final result = await remoteDataSource.getSearchSuggestions(
        limit: limit,
        days: days,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          _serverMessage(e) ?? 'Unable to load search suggestions.',
        ),
      );
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String? _serverMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map) {
      final errors = data['errors'];

      if (errors is Map) {
        final messages = <String>[];

        for (final value in errors.values) {
          if (value is List) {
            messages.addAll(value.map((item) => item.toString()));
          } else if (value != null) {
            messages.add(value.toString());
          }
        }

        if (messages.isNotEmpty) {
          return messages.join('\n');
        }
      }

      for (final key in const ['message', 'detail', 'title']) {
        final value = data[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
    }

    return e.message;
  }
}

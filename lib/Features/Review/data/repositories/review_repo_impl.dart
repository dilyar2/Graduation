import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/Review/data/dataSource/review_data_source.dart';
import 'package:graduation2/Features/Review/domain/repo/review_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ReviewRepo)
class ReviewRepoImpl implements ReviewRepo {
  final ReviewRemoteDataSource reviewRemoteDataSource;

  ReviewRepoImpl({
    required this.reviewRemoteDataSource,
  });

  @override
  Future<Either<Failure, Unit>> addReview({
    required int enrollmentId,
    required int rating,
    required String comment,
  }) async {
    try {
      await reviewRemoteDataSource.addReview(
        enrollmentId: enrollmentId,
        rating: rating,
        comment: comment,
      );

      return const Right(unit);
    } on DioException catch (e) {
      final message = _readServerMessage(e.response?.data);

      if (e.response?.statusCode == 409) {
        return Left(
          ServerFailure(
            message ?? 'You have already reviewed this course.',
          ),
        );
      }

      return Left(
        ServerFailure(
          message ?? e.message ?? 'Failed to add review',
        ),
      );
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure(
          'Unexpected error while adding review: $e',
        ),
      );
    }
  }

  String? _readServerMessage(dynamic data) {
    if (data is! Map) return null;

    for (final key in const ['message', 'title', 'detail', 'error']) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    return null;
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/quiz/data/datasources/quiz_data_source.dart';
import 'package:graduation2/Features/quiz/data/models/quiz_model.dart';
import 'package:graduation2/Features/quiz/domain/repositories/quiz_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: QuizRepo)
class QuizRepoImpl implements QuizRepo {
  final QuizDataSource quizDataSource;

  QuizRepoImpl({
    required this.quizDataSource,
  });

  @override
  Future<Either<Failure, QuizModel>> getSectionQuiz({
    required int courseId,
    required int sectionId,
  }) async {
    try {
      final data = await quizDataSource.getSectionQuiz(
        courseId: courseId,
        sectionId: sectionId,
      );

      return Right(QuizModel.fromJson(data));
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? data['message']?.toString() ??
              data['title']?.toString() ??
              data['detail']?.toString() ??
              data['error']?.toString()
          : null;

      return Left(
        ServerFailure(
          message ?? e.message ?? 'Failed to load quiz',
        ),
      );
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error while loading quiz: $e'),
      );
    }
  }
}

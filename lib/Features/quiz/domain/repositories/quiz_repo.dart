import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/quiz/data/models/quiz_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class QuizRepo {
  Future<Either<Failure, QuizModel>> getSectionQuiz({
    required int courseId,
    required int sectionId,
  });
}

import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/quiz/data/models/quiz_model.dart';
import 'package:graduation2/Features/quiz/domain/repositories/quiz_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSectionQuizUseCase {
  final QuizRepo repository;

  GetSectionQuizUseCase(this.repository);

  Future<Either<Failure, QuizModel>> call({
    required int courseId,
    required int sectionId,
  }) {
    return repository.getSectionQuiz(
      courseId: courseId,
      sectionId: sectionId,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/quiz/data/models/quiz_model.dart';
import 'package:graduation2/Features/quiz/domain/usecases/get_section_quiz_use_case.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

@injectable
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetSectionQuizUseCase getSectionQuizUseCase;

  QuizBloc({
    required this.getSectionQuizUseCase,
  }) : super(QuizInitial()) {
    on<GetQuizEvent>(_onGetQuiz);
  }

  Future<void> _onGetQuiz(
    GetQuizEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizLoading());

    try {
      final result = await getSectionQuizUseCase(
        courseId: event.courseId,
        sectionId: event.sectionId,
      );

      result.fold(
        (failure) => emit(
          QuizError(message: failure.message),
        ),
        (quiz) => emit(
          QuizLoaded(quiz: quiz),
        ),
      );
    } on Failure catch (failure) {
      emit(QuizError(message: failure.message));
    } catch (_) {
      emit(
        const QuizError(
          message: 'Unexpected error while loading quiz',
        ),
      );
    }
  }
}

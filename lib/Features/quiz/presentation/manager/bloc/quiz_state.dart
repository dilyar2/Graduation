part of 'quiz_bloc.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final QuizModel quiz;

  const QuizLoaded({
    required this.quiz,
  });

  @override
  List<Object?> get props => [quiz];
}

class QuizError extends QuizState {
  final String message;

  const QuizError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class GetQuizEvent extends QuizEvent {
  final int courseId;
  final int sectionId;

  const GetQuizEvent({
    required this.courseId,
    required this.sectionId,
  });

  @override
  List<Object?> get props => [courseId, sectionId];
}

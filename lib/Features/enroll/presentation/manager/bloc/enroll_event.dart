part of 'enroll_bloc.dart';

sealed class EnrollEvent extends Equatable {
  const EnrollEvent();

  @override
  List<Object> get props => [];
}

class EnrollCourseEvent extends EnrollEvent {
  final int courseId;

  const EnrollCourseEvent({
    required this.courseId,
  });

  @override
  List<Object> get props => [courseId];
}

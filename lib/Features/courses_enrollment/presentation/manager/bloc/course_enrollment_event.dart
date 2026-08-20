part of 'course_enrollment_bloc.dart';

abstract class CoursesEnrollmentEvent extends Equatable {
  const CoursesEnrollmentEvent();

  @override
  List<Object?> get props => [];
}

class GetCoursesEnrollmentEvent extends CoursesEnrollmentEvent {
  final bool unpaidOnly;

  const GetCoursesEnrollmentEvent({
    required this.unpaidOnly,
  });

  @override
  List<Object?> get props => [unpaidOnly];
}

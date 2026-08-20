part of 'course_enrollment_bloc.dart';


abstract class CoursesEnrollmentState extends Equatable {
  const CoursesEnrollmentState();

  @override
  List<Object?> get props => [];
}

class CoursesEnrollmentInitial extends CoursesEnrollmentState {}

class CoursesEnrollmentLoading extends CoursesEnrollmentState {}

class CoursesEnrollmentLoaded extends CoursesEnrollmentState {
  final CoursesEnrollmentModel coursesEnrollmentModel;

  const CoursesEnrollmentLoaded(this.coursesEnrollmentModel);

  @override
  List<Object?> get props => [coursesEnrollmentModel];
}

class CoursesEnrollmentError extends CoursesEnrollmentState {
  final String message;

  const CoursesEnrollmentError(this.message);

  @override
  List<Object?> get props => [message];
}

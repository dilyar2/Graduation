part of 'course_by_teacher_bloc.dart';

abstract class TeacherCoursesState {}

class TeacherCoursesInitial extends TeacherCoursesState {}

class TeacherCoursesLoading extends TeacherCoursesState {}

class TeacherCoursesSuccess extends TeacherCoursesState {
  final List<CourseModel> courses;

  TeacherCoursesSuccess({required this.courses});
}

class TeacherCoursesFailure extends TeacherCoursesState {
  final String message;

  TeacherCoursesFailure({required this.message});
}

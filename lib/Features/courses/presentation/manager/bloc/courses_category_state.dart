part of 'courses_category_bloc.dart';
abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final CoursesByCategoryModel courses;

  CourseLoaded({required this.courses});
}

class CourseError extends CourseState {
  final String message;

  CourseError({required this.message});
}

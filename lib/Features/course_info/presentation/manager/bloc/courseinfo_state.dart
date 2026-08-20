part of 'courseinfo_bloc.dart';

abstract class CourseInfoState {}

class CourseInfoInitial extends CourseInfoState {}

class CourseInfoLoading extends CourseInfoState {}

class CourseInfoLoaded extends CourseInfoState {
  final CourseInfoModel courseInfoModel;

  CourseInfoLoaded({required this.courseInfoModel});
}

class CourseInfoError extends CourseInfoState {
  final String message;

  CourseInfoError({required this.message});
}

part of 'courseinfo_bloc.dart';

abstract class CourseInfoEvent {}

class GetCourseInfoEvent extends CourseInfoEvent {
  final int id;

  GetCourseInfoEvent({required this.id});
}

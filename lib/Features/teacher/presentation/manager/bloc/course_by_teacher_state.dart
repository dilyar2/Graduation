part of'course_by_teacher_bloc.dart';

abstract class TeacherCoursesEvent {}
class GetTeacherCoursesEvent extends TeacherCoursesEvent {
  final int teacherId;

  GetTeacherCoursesEvent({required this.teacherId});
}

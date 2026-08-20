part of 'teacher_bloc.dart';

abstract class TeacherEvent {
  const TeacherEvent();
}

class GetTeachersEvent extends TeacherEvent {
  final String? orderBy;

  const GetTeachersEvent({this.orderBy});
}








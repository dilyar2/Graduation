part of 'teacher_bloc.dart';

abstract class TeacherState {
  const TeacherState();
}

class TeacherInitial extends TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherLoaded extends TeacherState {
  final List<TeacherModel> teachers;
  final String? orderBy;
  final Map<int, Uint8List> image;

  const TeacherLoaded({
    required this.image,
    required this.teachers,
    this.orderBy,
  });
}

class TeacherError extends TeacherState {
  final String message;

  const TeacherError({required this.message});
}

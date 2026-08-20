part of 'section_bloc.dart';

abstract class SectionState {}

class SectionInitial extends SectionState {}

class SectionLoading extends SectionState {}

class SectionLoaded extends SectionState {
  final SectionModel sectionModel;

  SectionLoaded({required this.sectionModel});
}

class SectionError extends SectionState {
  final String message;

  SectionError({required this.message});
}


part of 'section_bloc.dart';

abstract class SectionEvent {}

class GetSectionByCourseEvent extends SectionEvent {


 final int id;

  GetSectionByCourseEvent({required this.id});

}

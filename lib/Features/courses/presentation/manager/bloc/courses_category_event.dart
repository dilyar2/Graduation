part of 'courses_category_bloc.dart';

abstract class CourseEvent {}

class GetCoursesByCategoryEvent extends CourseEvent {

  final String category;
  final String? search;
  final String? tags;
  final int page;
  final int pageSize;
  final String? orderBy;
  final String direction;

  GetCoursesByCategoryEvent({
    required this.category,
    this.search,
    this.tags,
    this.page = 1,
    this.pageSize = 10,
    this.orderBy,
    this.direction = 'desc',
  });
}

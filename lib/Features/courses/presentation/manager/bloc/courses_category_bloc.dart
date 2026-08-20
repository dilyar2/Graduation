import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/courses/domain/usecases/get_courses_by_category_usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/courses_by_category_model.dart';

part 'courses_category_event.dart';
part 'courses_category_state.dart';

@injectable
class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesByCategoryUseCase getCoursesByCategoryUseCase;

  CourseBloc({required this.getCoursesByCategoryUseCase})
      : super(CourseInitial()) {
    on<GetCoursesByCategoryEvent>(_getCoursesByCategory);
  }

  Future<void> _getCoursesByCategory(
    GetCoursesByCategoryEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());

    final result = await getCoursesByCategoryUseCase(
      category: event.category,
      search: event.search,
      tags: event.tags,
      page: event.page,
      pageSize: event.pageSize,
      orderBy: event.orderBy,
      direction: event.direction,
    );

    result.fold(
      (failure) => emit(CourseError(message: failure.message)),
      (courses) => emit(CourseLoaded(courses: courses)),
    );
  }
}

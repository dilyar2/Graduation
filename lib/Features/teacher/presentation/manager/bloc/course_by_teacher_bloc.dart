import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/Features/teacher/domain/usecases/get_all_courses_to_teacher_usecases.dart';
import 'package:injectable/injectable.dart';
part 'course_by_teacher_event.dart';
part 'course_by_teacher_state.dart';

@injectable
class TeacherCoursesBloc
    extends Bloc<TeacherCoursesEvent, TeacherCoursesState> {
  final GetAllCoursesToTeacherUsecases getAllCoursesToTeacherUsecases;

  TeacherCoursesBloc({
    required this.getAllCoursesToTeacherUsecases,
  }) : super(TeacherCoursesInitial()) {
    on<GetTeacherCoursesEvent>(_getTeacherCourses);
  }

  Future<void> _getTeacherCourses(
    GetTeacherCoursesEvent event,
    Emitter<TeacherCoursesState> emit,
  ) async {
    emit(TeacherCoursesLoading());

    final result = await getAllCoursesToTeacherUsecases(
      id: event.teacherId,
    );

    result.fold(
      (failure) => emit(
        TeacherCoursesFailure(
          message: failure.message,
        ),
      ),
      (courses) => emit(
        TeacherCoursesSuccess(
          courses: courses,
        ),
      ),
    );
  }
}

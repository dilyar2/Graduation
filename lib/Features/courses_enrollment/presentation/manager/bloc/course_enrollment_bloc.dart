
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/courses_enrollment/data/models/courses_enrollment_model.dart';
import 'package:graduation2/Features/courses_enrollment/domain/usecases/course_enrollment_use_cases.dart';
import 'package:injectable/injectable.dart';

part 'course_enrollment_event.dart';
part 'course_enrollment_state.dart';

@injectable
class CoursesEnrollmentBloc
    extends Bloc<CoursesEnrollmentEvent, CoursesEnrollmentState> {
  final CourseEnrollmentUseCases getCoursesEnrollmentUseCase;

  CoursesEnrollmentBloc({
    required this.getCoursesEnrollmentUseCase,
  }) : super(CoursesEnrollmentInitial()) {
    on<GetCoursesEnrollmentEvent>(_onGetCoursesEnrollment);
  }

  Future<void> _onGetCoursesEnrollment(
    GetCoursesEnrollmentEvent event,
    Emitter<CoursesEnrollmentState> emit,
  ) async {
    emit(CoursesEnrollmentLoading());

    final result = await getCoursesEnrollmentUseCase(
      unpaidOnly: event.unpaidOnly,
    );

    result.fold(
      (failure) => emit(CoursesEnrollmentError(failure.message)),
      (courses) => emit(CoursesEnrollmentLoaded(courses)),
    );
  }
}

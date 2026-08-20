import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/course_info/data/models/course_info_model.dart';
import 'package:graduation2/Features/course_info/domain/usecases/course_info_use_case.dart';
import 'package:injectable/injectable.dart';

part 'courseinfo_event.dart';
part 'courseinfo_state.dart';

@injectable
class CourseInfoBloc extends Bloc<CourseInfoEvent, CourseInfoState> {
  final CourseInfoUseCase courseInfoUseCase;

  CourseInfoBloc({required this.courseInfoUseCase})
    : super(CourseInfoInitial()) {
    on<GetCourseInfoEvent>((event, emit) async {
      emit(CourseInfoLoading());

      final result = await courseInfoUseCase(id: event.id);

      result.fold(
        (failure) {
          emit(CourseInfoError(message: failure.message));
        },
        (courses) {
          emit(CourseInfoLoaded(courseInfoModel: courses));
        },
      );
    });
  }
}

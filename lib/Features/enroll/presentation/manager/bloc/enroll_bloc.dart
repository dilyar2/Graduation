import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/enroll/data/models/enroll_model.dart';
import 'package:graduation2/Features/enroll/domain/usecases/enroll_use_cases.dart';
import 'package:injectable/injectable.dart';

part 'enroll_event.dart';
part 'enroll_state.dart';

@injectable
class EnrollBloc extends Bloc<EnrollEvent, EnrollState> {
  final EnrollUseCases enrollUseCase;

  EnrollBloc({required this.enrollUseCase}) : super(EnrollInitial()) {
    on<EnrollCourseEvent>(_onEnrollCourse);



  }

  Future<void> _onEnrollCourse(
    EnrollCourseEvent event,
    Emitter<EnrollState> emit,
  ) async {
    emit(EnrollLoading());

    final result = await enrollUseCase(id: event.courseId);

    result.fold(
      (failure) => emit(EnrollFailure(message: failure.message)),
      (enrollment) => emit(EnrollSuccess(enrollModel: enrollment)),
    );
  }
}

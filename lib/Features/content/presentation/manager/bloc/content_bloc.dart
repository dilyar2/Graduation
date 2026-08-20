import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/get_content_use_case.dart';

part 'content_event.dart';
part 'content_state.dart';
@injectable

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final GetContentUseCase getContentUseCase;

  ContentBloc({
    required this.getContentUseCase,
  }) : super(ContentInitial()) {
    on<GetContentEvent>(_onGetContent);
    on<MarkContentCompletedEvent>(_onMarkCompleted);
  }

  Future<void> _onGetContent(
    GetContentEvent event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());

    try {
      final result = await getContentUseCase(
        courseId: event.courseId,
        contentId: event.contentId,
      );

      result.fold(
        (failure) => emit(
          ContentError(message: failure.message),
        ),
        (file) => emit(
          ContentLoaded(file: file),
        ),
      );
    } on Failure catch (failure) {
      emit(ContentError(message: failure.message));
    } catch (_) {
      emit(const ContentError(message: 'Unexpected error while loading file'));
    }
  }

  Future<void> _onMarkCompleted(
    MarkContentCompletedEvent event,
    Emitter<ContentState> emit,
  ) async {
    final current = state;
    if (current is! ContentLoaded || current.updatingProgress || current.completed) return;

    emit(current.copyWith(updatingProgress: true, clearError: true));
    final result = await getContentUseCase.markCompleted(
      contentId: event.contentId,
      courseId: event.courseId,
      lastPosition: event.lastPosition,
    );
    result.fold(
      (failure) => emit(current.copyWith(
        updatingProgress: false,
        progressError: failure.message,
      )),
      (_) => emit(current.copyWith(
        updatingProgress: false,
        completed: true,
        clearError: true,
      )),
    );
  }

}

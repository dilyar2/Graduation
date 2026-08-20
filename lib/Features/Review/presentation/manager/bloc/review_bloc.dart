import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/Review/domain/usecases/review_use_case.dart';
import 'package:injectable/injectable.dart';

part 'review_event.dart';
part 'review_state.dart';

@injectable
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReviewUseCases addReviewUseCases;

  ReviewBloc({required this.addReviewUseCases}) : super(ReviewInitial()) {
    on<AddReviewEvent>(_onAddReview);
  }

  Future<void> _onAddReview(
    AddReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    try {
      final result = await addReviewUseCases(
        enrollmentId: event.enrollmentId,
        rating: event.rating,
        comment: event.comment,
      );

      result.fold(
        (failure) => emit(ReviewFailure(failure.message)),
        (_) => emit(ReviewSuccess()),
      );
    } catch (_) {
      emit(
        const ReviewFailure('Something went wrong while sending your review.'),
      );
    }
  }
}

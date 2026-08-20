part of 'review_bloc.dart';
abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class AddReviewEvent extends ReviewEvent {
  final int enrollmentId;
  final int rating;
  final String comment;

  const AddReviewEvent({
    required this.enrollmentId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [
        enrollmentId,
        rating,
        comment,
      ];
}

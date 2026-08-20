import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/Review/domain/repo/review_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddReviewUseCases {
  final ReviewRepo reviewRepo;

  AddReviewUseCases({required this.reviewRepo});

  Future<Either<Failure, Unit>> call({
    required int enrollmentId,
    required int rating,
    required String comment,
  }) {
    return reviewRepo.addReview(
      enrollmentId: enrollmentId,
      rating: rating,
      comment: comment,
    );
  }
}

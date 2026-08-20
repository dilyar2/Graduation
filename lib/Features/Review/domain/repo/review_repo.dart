import 'package:dartz/dartz.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class ReviewRepo {
  Future<Either<Failure, Unit>> addReview({
    required int enrollmentId,
    required int rating,
    required String comment,
  });
}

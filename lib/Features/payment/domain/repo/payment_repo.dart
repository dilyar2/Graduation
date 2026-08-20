import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/payment/data/models/payment_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class PaymentRepo {
  Future<Either<Failure, PaymentModel>> pay({required int enrollmentId});
}

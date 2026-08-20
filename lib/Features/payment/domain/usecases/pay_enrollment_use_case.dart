import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/payment/data/models/payment_model.dart';
import 'package:graduation2/Features/payment/domain/repo/payment_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class PayEnrollmentUseCase {
  final PaymentRepo paymentRepo;

  PayEnrollmentUseCase({required this.paymentRepo});

  Future<Either<Failure, PaymentModel>> call({required int enrollmentId}) {
    return paymentRepo.pay(enrollmentId: enrollmentId);
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/payment/data/datasource/payment_data_source.dart';
import 'package:graduation2/Features/payment/data/models/payment_model.dart';
import 'package:graduation2/Features/payment/domain/repo/payment_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PaymentRepo)
class PaymentRepoImpl implements PaymentRepo {
  final PaymentDataSource paymentDataSource;

  PaymentRepoImpl({required this.paymentDataSource});

  @override
  Future<Either<Failure, PaymentModel>> pay({required int enrollmentId}) async {
    try {
      final result = await paymentDataSource.payEnrollment(
        enrollmentId: enrollmentId,
      );

      if (!result.isSuccess) {
        return Left(
          ServerFailure(result.status ?? 'Payment was not completed'),
        );
      }

      return Right(result);
    } on DioException catch (e) {


      if (e.response?.statusCode == 409) {
        return Right(PaymentModel(enrollmentId: enrollmentId, status: 'paid'));
      }

      final serverMessage = _readServerMessage(e.response?.data);

      return Left(
        ServerFailure(
          serverMessage ?? e.message ?? 'Failed to process payment',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Unexpected error while paying: $e'));
    }
  }

  String? _readServerMessage(dynamic data) {
    if (data is! Map) {
      return null;
    }

    final values = [
      data['message'],
      data['title'],
      data['detail'],
      data['error'],
    ];

    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    return null;
  }
}

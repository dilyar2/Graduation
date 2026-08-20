import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/payment/data/models/payment_model.dart';
import 'package:graduation2/Features/payment/domain/usecases/pay_enrollment_use_case.dart';
import 'package:injectable/injectable.dart';

part 'payment_event.dart';
part 'payment_state.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PayEnrollmentUseCase payEnrollmentUseCase;

  PaymentBloc({required this.payEnrollmentUseCase}) : super(PaymentInitial()) {
    on<PayEnrollmentEvent>(_onPayEnrollment);
  }

  Future<void> _onPayEnrollment(
    PayEnrollmentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    final result = await payEnrollmentUseCase(enrollmentId: event.enrollmentId);

    result.fold(
      (failure) => emit(PaymentFailure(message: failure.message)),
      (payment) => emit(PaymentSuccess(paymentModel: payment)),
    );
  }
}

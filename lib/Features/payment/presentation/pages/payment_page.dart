import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/payment/presentation/manager/bloc/payment_bloc.dart';
import 'package:graduation2/core/di/injection.dart';
import 'package:graduation2/core/storage/enrollment_storage.dart';
import 'package:graduation2/core/storage/token_storage.dart';

class PaymentPage extends StatelessWidget {
  final int enrollmentId;
  final int courseId;
  final double amount;

  const PaymentPage({
    super.key,
    required this.enrollmentId,
    required this.courseId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              _handlePaymentSuccess(context, state);
            }
          },
          builder: (context, state) {
            final isLoading = state is PaymentLoading;
            final colors = Theme.of(context).colorScheme;

            if (isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Processing payment...'),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 52,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Complete your enrollment',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pay the course amount to unlock the learning content.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          _PaymentRow(
                            label: 'Course ID',
                            value: '$courseId',
                          ),
                          const SizedBox(height: 12),
                          _PaymentRow(
                            label: 'Enrollment ID',
                            value: '$enrollmentId',
                          ),
                          const Divider(height: 28),
                          _PaymentRow(
                            label: 'Amount',
                            value: _formatAmount(amount),
                            emphasize: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state is PaymentFailure) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.error_outline_rounded, color: colors.error),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              state.message,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        context.read<PaymentBloc>().add(
                          PayEnrollmentEvent(enrollmentId: enrollmentId),
                        );
                      },
                      icon: const Icon(Icons.payment_rounded),
                      label: Text(
                        state is PaymentFailure ? 'Retry Payment' : 'Pay Now',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handlePaymentSuccess(
    BuildContext context,
    PaymentSuccess state,
  ) async {
    final tokenStorage = getIt<TokenStorage>();
    final enrollmentStorage = getIt<EnrollmentStorage>();
    final userId = await tokenStorage.getUserId();



    if (userId != null && userId > 0) {
      await enrollmentStorage.markCoursePaid(
        userId: userId,
        courseId: courseId,
      );
    }

    if (!context.mounted) return;

    final wasAlreadyPaid =
        state.paymentModel.status?.trim().toLowerCase() == 'paid';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasAlreadyPaid
              ? 'This course was already paid. Your access is unlocked.'
              : 'Payment completed successfully.',
        ),
      ),
    );

    Navigator.pop(context, state.paymentModel);
  }

  static String _formatAmount(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _PaymentRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            )
        : Theme.of(context).textTheme.bodyLarge;

    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: style),
      ],
    );
  }
}

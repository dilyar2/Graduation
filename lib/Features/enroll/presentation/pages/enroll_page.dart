import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/enroll/presentation/manager/bloc/enroll_bloc.dart';
import 'package:graduation2/Features/payment/presentation/pages/payment_page.dart';
import 'package:graduation2/core/di/injection.dart';

class EnrollPage extends StatelessWidget {
  final int courseId;

  const EnrollPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EnrollBloc>()
        ..add(EnrollCourseEvent(courseId: courseId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Enroll in Course')),
        body: BlocConsumer<EnrollBloc, EnrollState>(
          listener: (context, state) {
            if (state is EnrollSuccess) {
              final model = state.enrollModel;
              if (model.enrollmentId == null || model.courseId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enrollment was created but its data is incomplete.'),
                  ),
                );
                return;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentPage(
                    enrollmentId: model.enrollmentId!,
                    courseId: model.courseId!,
                    amount: model.amount ?? 0,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is EnrollLoading || state is EnrollInitial) {
              return const _EnrollmentLoading();
            }

            if (state is EnrollFailure) {
              return _EnrollmentError(
                message: state.message,
                onRetry: () => context.read<EnrollBloc>().add(
                  EnrollCourseEvent(courseId: courseId),
                ),
              );
            }

            return const _EnrollmentLoading();
          },
        ),
      ),
    );
  }
}

class _EnrollmentLoading extends StatelessWidget {
  const _EnrollmentLoading();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: colors.primary),
            const SizedBox(height: 20),
            Text(
              'Creating your enrollment...',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Please wait a moment.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _EnrollmentError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _EnrollmentError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, size: 52, color: colors.error),
            const SizedBox(height: 16),
            Text(
              'Could not enroll in this course',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/quiz/data/models/quiz_model.dart';
import 'package:graduation2/Features/quiz/presentation/manager/bloc/quiz_bloc.dart';
import 'package:graduation2/core/di/injection.dart';

class QuizPage extends StatelessWidget {
  final int courseId;
  final int sectionId;

  const QuizPage({
    super.key,
    required this.courseId,
    required this.sectionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QuizBloc>()
        ..add(
          GetQuizEvent(
            courseId: courseId,
            sectionId: sectionId,
          ),
        ),
      child: QuizPageScope(
        courseId: courseId,
        sectionId: sectionId,
        child: const _QuizView(),
      ),
    );
  }
}

class _QuizView extends StatefulWidget {
  const _QuizView();

  @override
  State<_QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<_QuizView> {
  final Map<int, int> _selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Section Quiz'),
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading || state is QuizInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is QuizError) {
            return _ErrorState(
              message: state.message,
              onRetry: () {
                context.read<QuizBloc>().add(
                      GetQuizEvent(
                        courseId: context.read<QuizPageScope>().courseId,
                        sectionId: context.read<QuizPageScope>().sectionId,
                      ),
                    );
              },
            );
          }

          if (state is QuizLoaded) {
            final quiz = state.quiz;

            if (quiz.questions.isEmpty) {
              return _EmptyState(
                onRetry: () {
                  context.read<QuizPageScope>().reload(context);
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<QuizPageScope>().reload(context);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest.withValues(
                        alpha: .45,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              colors.primary.withValues(alpha: .12),
                          child: Icon(
                            Icons.quiz_outlined,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quiz.title,
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${quiz.questions.length} '
                                '${quiz.questions.length == 1 ? 'question' : 'questions'}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...quiz.questions.asMap().entries.map(
                        (entry) => _QuestionCard(
                          index: entry.key + 1,
                          question: entry.value,
                          selectedAnswer:
                              _selectedAnswers[entry.value.id],
                          onSelected: (answerId) {
                            setState(() {
                              _selectedAnswers[entry.value.id] = answerId;
                            });
                          },
                        ),
                      ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => _submitQuiz(
                      context,
                      quiz,
                    ),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Submit Quiz'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _submitQuiz(
    BuildContext context,
    QuizModel quiz,
  ) {
    final missing = <int>[];

    for (var i = 0; i < quiz.questions.length; i++) {
      if (!_selectedAnswers.containsKey(quiz.questions[i].id)) {
        missing.add(i + 1);
      }
    }

    if (missing.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please answer all questions. Missing: ${missing.join(', ')}',
          ),
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quiz submission'),
        content: const Text(
          'The current API exposes test submission as a binary file upload. '
          'The documented contract does not define the answer-file format, '
          'so the app will not send guessed data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class QuizPageScope extends InheritedWidget {
  final int courseId;
  final int sectionId;

  const QuizPageScope({
    super.key,
    required this.courseId,
    required this.sectionId,
    required super.child,
  });

  static QuizPageScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<QuizPageScope>()!;
  }

  void reload(BuildContext context) {
    context.read<QuizBloc>().add(
          GetQuizEvent(
            courseId: courseId,
            sectionId: sectionId,
          ),
        );
  }

  @override
  bool updateShouldNotify(covariant QuizPageScope oldWidget) {
    return courseId != oldWidget.courseId || sectionId != oldWidget.sectionId;
  }
}

class _QuestionCard extends StatelessWidget {
  final int index;
  final QuizQuestionModel question;
  final int? selectedAnswer;
  final ValueChanged<int> onSelected;

  const _QuestionCard({
    required this.index,
    required this.question,
    required this.selectedAnswer,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$index. ${question.title}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            if (question.answers.isEmpty)
              Text(
                'No answers available for this question.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              )
            else
              ...question.answers.map(
                (answer) => RadioListTile<int>(
                  value: answer.id,
                  groupValue: selectedAnswer,
                  onChanged: (value) {
                    if (value != null) {
                      onSelected(value);
                    }
                  },
                  title: Text(answer.text),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptyState({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 52,
              color: colors.primary,
            ),
            const SizedBox(height: 12),
            const Text(
              'No quiz available for this section yet.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 52,
              color: colors.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

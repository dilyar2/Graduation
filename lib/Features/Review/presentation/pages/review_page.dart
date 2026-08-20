import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/Review/presentation/manager/bloc/review_bloc.dart';

class StarRatingSheet extends StatefulWidget {
  final int enrollmentId;
  final String title;
  final String? subtitle;

  const StarRatingSheet({
    super.key,
    required this.enrollmentId,
    this.title = 'Rate your experience',
    this.subtitle,
  });

  @override
  State<StarRatingSheet> createState() => _StarRatingSheetState();
}

class _StarRatingSheetState extends State<StarRatingSheet> {
  int _rating = 0;

  final TextEditingController _commentController =
      TextEditingController();

  static const List<String> _labels = [
    '',
    'Bad',
    'Weak',
    'Average',
    'Good',
    'Great',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) return;

    final comment = _commentController.text.trim();

    if (comment.length > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your review must be 500 characters or less.',
          ),
        ),
      );
      return;
    }

    context.read<ReviewBloc>().add(
          AddReviewEvent(
            enrollmentId: widget.enrollmentId,
            rating: _rating,
            comment: comment,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is ReviewSuccess) {
          Navigator.of(context).pop(true);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Review submitted successfully.'),
            ),
          );
        }

        if (state is ReviewFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  widget.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      final filled = value <= _rating;

                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _rating = value;
                          });
                        },
                        icon: Icon(
                          filled
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 42,
                          color: filled
                              ? colors.secondary
                              : colors.outline,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _rating > 0
                      ? _labels[_rating]
                      : 'Your rating helps us improve',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  maxLength: 500,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Write a comment (optional)',
                    filled: true,
                    fillColor: colors.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colors.outlineVariant,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colors.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<ReviewBloc, ReviewState>(
                  builder: (context, state) {
                    final loading = state is ReviewLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed:
                            loading || _rating == 0 ? null : _submit,
                        icon: loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send_rounded),
                        label: Text(
                          loading ? 'Sending...' : 'Send Review',
                        ),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

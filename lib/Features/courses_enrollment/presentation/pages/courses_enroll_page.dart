import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/courses_enrollment/presentation/manager/bloc/course_enrollment_bloc.dart';
import 'package:graduation2/Features/courses_enrollment/presentation/pages/course_enroll_section.dart';
import 'package:graduation2/core/di/injection.dart';

class CourseEnrollPage extends StatefulWidget {
  const CourseEnrollPage({super.key});

  @override
  State<CourseEnrollPage> createState() => _CourseEnrollPageState();
}

class _CourseEnrollPageState extends State<CourseEnrollPage> {
  bool _unpaidOnly = false;

  void _load(BuildContext context) {
    context.read<CoursesEnrollmentBloc>().add(
      GetCoursesEnrollmentEvent(unpaidOnly: _unpaidOnly),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocProvider(
      create: (_) => getIt<CoursesEnrollmentBloc>()
        ..add(const GetCoursesEnrollmentEvent(unpaidOnly: false)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Learning'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                tooltip: 'Refresh',
                onPressed: () => _load(context),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ),
          ],
        ),
        body: BlocBuilder<CoursesEnrollmentBloc, CoursesEnrollmentState>(
          builder: (context, state) {
            if (state is CoursesEnrollmentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CoursesEnrollmentError) {
              return _StateView(
                icon: Icons.cloud_off_rounded,
                title: 'My Learning is unavailable',
                message: state.message,
                action: () => _load(context),
                actionLabel: 'Retry',
              );
            }

            if (state is! CoursesEnrollmentLoaded) {
              return const SizedBox.shrink();
            }

            final courses = state.coursesEnrollmentModel.items ?? [];

            return RefreshIndicator(
              onRefresh: () async {
                _load(context);
                await Future<void>.delayed(const Duration(milliseconds: 350));
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Continue your learning',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Open a course and continue from where you stopped.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment(
                                value: false,
                                icon: Icon(Icons.menu_book_outlined),
                                label: Text('All'),
                              ),
                              ButtonSegment(
                                value: true,
                                icon: Icon(Icons.payment_outlined),
                                label: Text('Unpaid'),
                              ),
                            ],
                            selected: {_unpaidOnly},
                            onSelectionChanged: (value) {
                              setState(() => _unpaidOnly = value.first);
                              _load(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (courses.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _StateView(
                        icon: Icons.menu_book_outlined,
                        title: _unpaidOnly
                            ? 'No unpaid courses'
                            : 'No courses yet',
                        message: _unpaidOnly
                            ? 'You do not have any unpaid enrollments.'
                            : 'Enroll in a course to start learning.',
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
                      sliver: SliverList.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _LearningCard(
                              item: course,
                              onTap: course.id == null ||
                                      course.enrollmentId == null
                                  ? null
                                  : () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CourseEnrollSectionPage(
                                            enrollId: course.enrollmentId!,
                                            id: course.id!,
                                          ),
                                        ),
                                      ),
                            ),
                          );
                        },
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
}

class _LearningCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback? onTap;

  const _LearningCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final progress = ((item.progress ?? 0) as num).clamp(0, 100).toDouble();
    final completed = item.completedContents ?? 0;
    final total = item.totalContents ?? 0;
    final title = (item.title ?? 'Untitled course').toString();
    final description = (item.description ?? '').toString().trim();
    final imageUrl = (item.imageUrl ?? '').toString().trim();
    final isCompleted = item.isCompleted == true;
    final status = (item.status ?? '').toString().trim().toLowerCase();
    final unpaid = status.contains('unpaid') ||
        status.contains('pending') ||
        status.contains('payment');

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 8.5,
                  child: imageUrl.isEmpty
                      ? _placeholder(context)
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(context),
                        ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: .92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isCompleted ? 'Completed' : 'In progress',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isCompleted
                            ? colors.primary
                            : colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (unpaid)
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colors.errorContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Unpaid',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.onErrorContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colors.primary,
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: colors.secondary,
                        size: 19,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        ((item.averageRating ?? 0) as num).toStringAsFixed(1),
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.visibility_outlined,
                        color: colors.onSurfaceVariant,
                        size: 19,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${item.watchCount ?? 0}',
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress / 100,
                            minHeight: 9,
                            backgroundColor: colors.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${progress.round()}%',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Text(
                        '$completed of $total lessons completed',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Continue',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.menu_book_rounded,
        size: 56,
        color: colors.primary,
      ),
    );
  }
}

class _StateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? action;
  final String? actionLabel;

  const _StateView({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 54, color: colors.primary),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (action != null) ...[
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: action,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel ?? 'Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

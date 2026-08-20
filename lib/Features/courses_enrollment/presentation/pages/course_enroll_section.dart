import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/Review/presentation/manager/bloc/review_bloc.dart';
import 'package:graduation2/Features/Review/presentation/pages/review_page.dart';
import 'package:graduation2/Features/content/presentation/pages/content_page.dart';
import 'package:graduation2/Features/course_info/data/models/course_info_model.dart';
import 'package:graduation2/Features/course_info/presentation/manager/bloc/courseinfo_bloc.dart';
import 'package:graduation2/Features/quiz/presentation/pages/quiz_page.dart';
import 'package:graduation2/core/di/injection.dart';
import 'package:graduation2/core/utils/course_progress.dart';

class CourseEnrollSectionPage extends StatelessWidget {
  final int id;
  final int enrollId;

  const CourseEnrollSectionPage({
    super.key,
    required this.id,
    required this.enrollId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<CourseInfoBloc>()
            ..add(GetCourseInfoEvent(id: id)),
        ),
        BlocProvider(create: (_) => getIt<ReviewBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('My Course')),
        body: BlocBuilder<CourseInfoBloc, CourseInfoState>(
          builder: (context, state) {
            if (state is CourseInfoInitial || state is CourseInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CourseInfoError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        size: 52,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is! CourseInfoLoaded) {
              return const SizedBox.shrink();
            }

            final course = state.courseInfoModel;
            final sections = course.sections ?? [];
            final courseProgress = CourseProgress.fromCourse(course);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CourseInfoBloc>().add(
                  GetCourseInfoEvent(id: id),
                );
                await Future<void>.delayed(
                  const Duration(milliseconds: 350),
                );
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                children: [
                  _LearningHero(
                    title: course.title ?? 'Course',
                    imageUrl: course.imageUrl ?? '',
                    rating: course.averageRating ?? 0,
                    views: course.watchCount ?? 0,
                  ),
                  const SizedBox(height: 16),
                  _ProgressCard(
                    progress: courseProgress.progress,
                    completed: courseProgress.completed,
                    total: courseProgress.total,
                    isCompleted: courseProgress.isCompleted,
                  ),
                  const SizedBox(height: 12),
                  _ContinueLearningButton(
                    course: course,
                    courseId: id,
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Course Content',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(
                        '${sections.length} sections',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (sections.isEmpty)
                    _EmptyCard(
                      message: 'No sections available for this course.',
                    )
                  else
                    ...sections.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _LearningSectionCard(
                          number: entry.key + 1,
                          section: entry.value,
                          courseId: id,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        showModalBottomSheet<bool>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => BlocProvider.value(
                            value: context.read<ReviewBloc>(),
                            child: StarRatingSheet(
                              title: 'Rate this course',
                              subtitle: 'Share your experience with this course.',
                              enrollmentId: enrollId,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.star_outline_rounded),
                      label: const Text('Review Course'),
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

class _LearningHero extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double rating;
  final int views;

  const _LearningHero({
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.views,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 8.5,
            child: imageUrl.trim().isEmpty
                ? _imagePlaceholder(context)
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(context),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: colors.secondary),
                    const SizedBox(width: 5),
                    Text(rating.toStringAsFixed(1)),
                    const SizedBox(width: 18),
                    Icon(
                      Icons.visibility_outlined,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                    Text('$views'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.menu_book_rounded,
        size: 58,
        color: colors.primary,
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int progress;
  final int completed;
  final int total;
  final bool isCompleted;

  const _ProgressCard({
    required this.progress,
    required this.completed,
    required this.total,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colors.primaryContainer.withValues(alpha: .35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.primary.withValues(alpha: .14)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isCompleted ? 'Course Completed' : 'Your Progress',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '$progress%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 9,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$completed / $total lessons completed',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _LearningSectionCard extends StatelessWidget {
  final int number;
  final dynamic section;
  final int courseId;

  const _LearningSectionCard({
    required this.number,
    required this.section,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final contents = section.contents ?? [];
    final completedCount =
        contents.where((content) => content.isCompleted == true).length;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: ExpansionTile(
        initiallyExpanded: number == 1,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        leading: CircleAvatar(
          backgroundColor: colors.primaryContainer,
          foregroundColor: colors.onPrimaryContainer,
          child: Text('$number'),
        ),
        title: Text(
          section.title ?? 'Section',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          contents.isEmpty
              ? 'No lessons'
              : '$completedCount/${contents.length} lessons completed',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          if (contents.isEmpty)
            Padding(
              padding: const EdgeInsets.all(14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No lessons available yet.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          else
            ...contents.map(
              (content) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: colors.surfaceContainerHighest.withValues(alpha: .45),
                  borderRadius: BorderRadius.circular(14),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: Icon(
                      content.isCompleted == true
                          ? Icons.check_circle_rounded
                          : Icons.play_circle_outline_rounded,
                      color: content.isCompleted == true
                          ? colors.primary
                          : colors.secondary,
                    ),
                    title: Text(
                      content.title ?? 'Lesson',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      content.isCompleted == true
                          ? 'Completed'
                          : (content.lastPosition ?? 0) > 0
                              ? 'Continue from ${content.lastPosition} sec'
                              : (content.description?.trim().isNotEmpty == true
                                  ? content.description!.trim()
                                  : 'Open lesson'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: content.id == null
                        ? null
                        : () async {
                            final changed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ContentPage(
                                  courseId: courseId,
                                  contentId: content.id!,
                                  title: content.title,
                                  contentType: content.contentType,
                                  description: content.description,
                                  duration: content.duration,
                                  initialCompleted:
                                      content.isCompleted == true,
                                  initialLastPosition:
                                      content.lastPosition ?? 0,
                                ),
                              ),
                            );
                            if (changed == true && context.mounted) {
                              context.read<CourseInfoBloc>().add(
                                GetCourseInfoEvent(id: courseId),
                              );
                            }
                          },
                  ),
                ),
              ),
            ),
          if (section.id != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizPage(
                        courseId: courseId,
                        sectionId: section.id!,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.quiz_outlined),
                label: const Text('Open Section Quiz'),
              ),
            ),
        ],
      ),
    );
  }
}


class _ContinueLearningButton extends StatelessWidget {
  final CourseInfoModel course;
  final int courseId;

  const _ContinueLearningButton({
    required this.course,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final sections = course.sections ?? const <Sections>[];

    Contents? nextContent;

    for (final section in sections) {
      for (final content in section.contents ?? const <Contents>[]) {
        if (content.id != null && content.isCompleted != true) {
          nextContent = content;
          break;
        }
      }
      if (nextContent != null) break;
    }

    final colors = Theme.of(context).colorScheme;

    if (nextContent == null) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.tonalIcon(
          onPressed: null,
          icon: Icon(
            Icons.verified_rounded,
            color: colors.primary,
          ),
          label: const Text('All lessons completed'),
        ),
      );
    }

    final content = nextContent;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () async {
          final changed = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => ContentPage(
                courseId: courseId,
                contentId: content.id!,
                title: content.title,
                contentType: content.contentType,
                description: content.description,
                duration: content.duration,
                initialCompleted: content.isCompleted == true,
                initialLastPosition: content.lastPosition ?? 0,
              ),
            ),
          );

          if (changed == true && context.mounted) {
            context.read<CourseInfoBloc>().add(
              GetCourseInfoEvent(id: courseId),
            );
          }
        },
        icon: const Icon(Icons.play_arrow_rounded),
        label: Text(
          (content.lastPosition ?? 0) > 0
              ? 'Continue Learning'
              : 'Start Learning',
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(message),
      ),
    );
  }
}

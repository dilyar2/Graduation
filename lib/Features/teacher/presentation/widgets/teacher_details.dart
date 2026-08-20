import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/courses/presentation/widgets/custom_course_card.dart';
import 'package:graduation2/Features/teacher/data/models/teacher_model.dart';
import 'package:graduation2/Features/teacher/presentation/manager/bloc/course_by_teacher_bloc.dart';
import 'package:graduation2/app_router.dart';
import 'package:graduation2/core/di/injection.dart';

class TeacherDetails extends StatelessWidget {
  const TeacherDetails({
    super.key,
    required this.teacherModel,
    required this.img,
  });

  final TeacherModel teacherModel;
  final Uint8List img;

  @override
  Widget build(BuildContext context) {
    final teacherId = teacherModel.userId;

    return BlocProvider(
      create: (_) => getIt<TeacherCoursesBloc>()
        ..add(GetTeacherCoursesEvent(teacherId: teacherId ?? 0)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Instructor Profile'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (teacherId == null) return;
            context
                .read<TeacherCoursesBloc>()
                .add(GetTeacherCoursesEvent(teacherId: teacherId));
            await Future<void>.delayed(const Duration(milliseconds: 350));
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              _Header(
                teacher: teacherModel,
                image: img,
              ),
              const SizedBox(height: 16),
              _Stats(teacher: teacherModel),
              const SizedBox(height: 20),
              Text(
                'About instructor',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                (teacherModel.bio ?? '').trim().isEmpty
                    ? 'No biography available yet.'
                    : teacherModel.bio!.trim(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Courses',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<TeacherCoursesBloc, TeacherCoursesState>(
                builder: (context, state) {
                  if (state is TeacherCoursesLoading ||
                      state is TeacherCoursesInitial) {
                    return const Padding(
                      padding: EdgeInsets.all(28),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is TeacherCoursesFailure) {
                    return _InlineError(
                      message: state.message,
                      onRetry: teacherId == null
                          ? null
                          : () => context
                              .read<TeacherCoursesBloc>()
                              .add(GetTeacherCoursesEvent(teacherId: teacherId)),
                    );
                  }

                  if (state is TeacherCoursesSuccess) {
                    if (state.courses.isEmpty) {
                      return const _EmptyCourses();
                    }

                    return SizedBox(
                      height: 235,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.courses.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, index) {
                          final course = state.courses[index];
                          return CustomCourseCard(
                            image: course.imageUrl,
                            courseName: course.title ?? 'Course',
                            title: course.title ?? 'Course',
                            description: course.description ?? '',
                            rating: course.averageRating ?? 0,
                            watchCount: course.watchCount ?? 0,
                            price: course.price,
                            onTap: course.id == null
                                ? null
                                : () => Navigator.pushNamed(
                                      context,
                                      AppRouter.courseDetails,
                                      arguments: course.id!,
                                    ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final TeacherModel teacher;
  final Uint8List image;

  const _Header({required this.teacher, required this.image});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final name = '${teacher.firstName ?? ''} ${teacher.lastName ?? ''}'.trim();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary.withValues(alpha: .14),
            colors.secondary.withValues(alpha: .08),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.primary.withValues(alpha: .18)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 58,
            backgroundColor: colors.primary.withValues(alpha: .14),
            backgroundImage: image.isNotEmpty ? MemoryImage(image) : null,
            child: image.isNotEmpty
                ? null
                : Icon(Icons.person_rounded, size: 62, color: colors.primary),
          ),
          const SizedBox(height: 14),
          Text(
            name.isEmpty ? 'Instructor' : name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            (teacher.specialization ?? '').trim().isEmpty
                ? 'Instructor'
                : teacher.specialization!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final TeacherModel teacher;

  const _Stats({required this.teacher});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            value: (teacher.averageRating ?? 0).toStringAsFixed(1),
            label: 'Rating',
            color: colors.secondary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.visibility_outlined,
            value: '${teacher.viewCount ?? 0}',
            label: 'Views',
            color: colors.primary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: Theme.of(context).textTheme.titleMedium),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCourses extends StatelessWidget {
  const _EmptyCourses();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'This instructor has no published courses yet.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _InlineError({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}

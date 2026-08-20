import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/content/presentation/pages/content_page.dart';
import 'package:graduation2/Features/quiz/presentation/pages/quiz_page.dart';
import 'package:graduation2/Features/course_info/data/models/course_info_model.dart';
import 'package:graduation2/Features/course_info/presentation/manager/bloc/courseinfo_bloc.dart';
import 'package:graduation2/Features/courses_enrollment/data/models/courses_enrollment_model.dart';
import 'package:graduation2/Features/courses_enrollment/presentation/manager/bloc/course_enrollment_bloc.dart';
import 'package:graduation2/Features/enroll/presentation/pages/enroll_page.dart';
import 'package:graduation2/Features/payment/presentation/pages/payment_page.dart';
import 'package:graduation2/core/di/injection.dart';
import 'package:graduation2/core/network/api_config.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:graduation2/core/storage/enrollment_storage.dart';
import 'package:graduation2/core/storage/token_storage.dart';
import 'package:graduation2/core/utils/course_progress.dart';

class CourseDetailsPage extends StatelessWidget {
  final int courseId;
  const CourseDetailsPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<CourseInfoBloc>()..add(GetCourseInfoEvent(id: courseId)),
        ),
        BlocProvider(
          create: (_) =>
              getIt<CoursesEnrollmentBloc>()
                ..add(const GetCoursesEnrollmentEvent(unpaidOnly: false)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Course Details')),
        body: BlocBuilder<CourseInfoBloc, CourseInfoState>(
          builder: (context, state) {
            if (state is CourseInfoInitial || state is CourseInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CourseInfoError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => context.read<CourseInfoBloc>().add(
                  GetCourseInfoEvent(id: courseId),
                ),
              );
            }

            if (state is CourseInfoLoaded) {
              return _CourseDetailsBody(
                course: state.courseInfoModel,
                courseId: courseId,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _CourseDetailsBody extends StatelessWidget {
  final CourseInfoModel course;
  final int courseId;

  const _CourseDetailsBody({required this.course, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final sections = course.sections ?? const <Sections>[];
    final imageUrl = _resolveImageUrl(course.imageUrl, courseId);
    final colors = Theme.of(context).colorScheme;
    final courseProgress = CourseProgress.fromCourse(course);
    final hasEnrollment =
        (course.enrollmentId ?? 0) > 0 ||
        (course.enrolledAt?.trim().isNotEmpty ?? false);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CourseInfoBloc>().add(GetCourseInfoEvent(id: courseId));
        await Future<void>.delayed(const Duration(milliseconds: 350));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _HeroCard(course: course, imageUrl: imageUrl),
          const SizedBox(height: 16),
          if (course.categories?.isNotEmpty == true)
            _TagSection(title: 'Categories', values: course.categories!),
          if (course.tags?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _TagSection(title: 'Tags', values: course.tags!),
          ],
          const SizedBox(height: 16),
          _InfoCard(
            title: 'About this course',
            icon: Icons.menu_book_outlined,
            child: Text(
              course.description?.trim().isNotEmpty == true
                  ? course.description!.trim()
                  : 'No description available.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.55,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          if (hasEnrollment) ...[
            const SizedBox(height: 16),
            _ProgressCard(
              progress: courseProgress.progress,
              completed: courseProgress.completed,
              total: courseProgress.total,
              isCompleted: courseProgress.isCompleted,
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Course Content',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Text(
                '${sections.length} sections',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          FutureBuilder<bool>(
            future: _isLocallyPaid(courseId),
            builder: (context, snapshot) {
              final localPaid = snapshot.data ?? false;
              final backendPaid = _hasPaidEnrollment(context, courseId);
              final hasPaidAccess = localPaid || backendPaid;

              if (sections.isEmpty) {
                return const _EmptyCard(message: 'No sections are available yet.');
              }

              return Column(
                children: sections.asMap().entries.map((entry) {
                  return _SectionTile(
                    index: entry.key + 1,
                    section: entry.value,
                    courseId: courseId,
                    hasPaidAccess: hasPaidAccess,
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          _EnrollmentAction(courseId: courseId, course: course),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final CourseInfoModel course;
  final String imageUrl;

  const _HeroCard({required this.course, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 8.5,
            child: imageUrl.isEmpty
                ? const _ImagePlaceholder()
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title?.trim().isNotEmpty == true
                      ? course.title!
                      : 'Untitled Course',
                  style: theme.textTheme.headlineSmall,
                ),
                if (course.slug?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(course.slug!, style: theme.textTheme.bodySmall),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    _Stat(
                      icon: Icons.star_rounded,
                      value: (course.averageRating ?? 0).toStringAsFixed(1),
                      label: 'Rating',
                    ),
                    _Stat(
                      icon: Icons.visibility_outlined,
                      value: '${course.watchCount ?? 0}',
                      label: 'Views',
                    ),
                    _Stat(
                      icon: Icons.payments_outlined,
                      value: _formatPrice(course.price),
                      label: 'Price',
                      accent: colors.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? accent;

  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = accent ?? colors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(value, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _TagSection extends StatelessWidget {
  final String title;
  final List<String> values;

  const _TagSection({required this.title, required this.values});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final valid = values.where((e) => e.trim().isNotEmpty).toList();
    if (valid.isEmpty) return const SizedBox.shrink();

    return _InfoCard(
      title: title,
      icon: Icons.sell_outlined,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: valid
            .map(
              (value) => Chip(
                label: Text(value),
                side: BorderSide(color: colors.primary.withValues(alpha: .35)),
                backgroundColor: colors.primary.withValues(alpha: .08),
                labelStyle: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: colors.primary),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
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
    final value = (progress / 100).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isCompleted ? 'Course completed' : 'Your progress',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  '$progress%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: value),
            const SizedBox(height: 8),
            Text(
              '$completed / $total contents completed',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTile extends StatefulWidget {
  final int index;
  final Sections section;
  final int courseId;
  final bool hasPaidAccess;

  const _SectionTile({
    required this.index,
    required this.section,
    required this.courseId,
    required this.hasPaidAccess,
  });

  @override
  State<_SectionTile> createState() => _SectionTileState();
}

class _SectionTileState extends State<_SectionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final contents = widget.section.contents ?? const <Contents>[];
    final completedCount =
        contents.where((content) => content.isCompleted == true).length;
    final title = widget.section.title?.trim().isNotEmpty == true
        ? widget.section.title!.trim()
        : 'Section ${widget.index}';
    final description = widget.section.description?.trim() ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 12, 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.index}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                contents.isEmpty
                                    ? 'No lessons yet'
                                    : '$completedCount/${contents.length} lessons completed',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            if (!widget.hasPaidAccess)
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 17,
                                color: colors.onSurfaceVariant,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: colors.primary,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _SectionContent(
              contents: contents,
              courseId: widget.courseId,
              sectionId: widget.section.id ?? 0,
              hasPaidAccess: widget.hasPaidAccess,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final List<Contents> contents;
  final int courseId;
  final int sectionId;
  final bool hasPaidAccess;

  const _SectionContent({
    required this.contents,
    required this.courseId,
    required this.sectionId,
    required this.hasPaidAccess,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: [
          if (contents.isEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'No content available yet.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...contents.asMap().entries.map((entry) {
              final content = entry.value;
              final canOpen = content.id != null && hasPaidAccess;

              return Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  enabled: canOpen,
                  leading: Icon(
                    canOpen
                        ? _contentIcon(content.contentType)
                        : Icons.lock_outline_rounded,
                    color: canOpen ? colors.primary : colors.onSurfaceVariant,
                  ),
                  title: Text(
                    content.title?.trim().isNotEmpty == true
                        ? content.title!.trim()
                        : 'Lesson ${entry.key + 1}',
                  ),
                  subtitle: _contentSubtitle(context, content),
                  trailing: canOpen
                      ? Icon(
                          Icons.chevron_right_rounded,
                          color: colors.primary,
                        )
                      : null,
                  onTap: canOpen
                      ? () async {
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
                        }
                      : null,
                ),
              );
            }),
          if (sectionId > 0) ...[
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  hasPaidAccess
                      ? Icons.quiz_outlined
                      : Icons.lock_outline_rounded,
                  color: hasPaidAccess
                      ? colors.primary
                      : colors.onSurfaceVariant,
                ),
                title: const Text('Section Quiz'),
                subtitle: Text(
                  hasPaidAccess
                      ? 'Test your knowledge'
                      : 'Unlock the course to continue',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                trailing: Icon(
                  hasPaidAccess
                      ? Icons.chevron_right_rounded
                      : Icons.lock_outline_rounded,
                  color: hasPaidAccess
                      ? colors.primary
                      : colors.onSurfaceVariant,
                ),
                onTap: hasPaidAccess
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizPage(
                              courseId: courseId,
                              sectionId: sectionId,
                            ),
                          ),
                        );
                      }
                    : null,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget? _contentSubtitle(BuildContext context, Contents content) {
    final description = content.description?.trim() ?? '';
    final duration = content.duration;
    final parts = <String>[];

    if (description.isNotEmpty) {
      parts.add(description);
    }

    if (duration != null && duration > 0) {
      parts.add('$duration min');
    }

    if (parts.isEmpty) return null;

    return Text(
      parts.join(' • '),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  IconData _contentIcon(String? type) {
    final value = type?.toLowerCase() ?? '';

    if (value.contains('pdf')) {
      return Icons.picture_as_pdf_outlined;
    }

    if (value.contains('file') || value.contains('document')) {
      return Icons.insert_drive_file_outlined;
    }

    if (value.contains('image')) {
      return Icons.image_outlined;
    }

    return Icons.play_circle_outline_rounded;
  }
}

class _EnrollmentAction extends StatefulWidget {
  final int courseId;
  final CourseInfoModel course;

  const _EnrollmentAction({required this.courseId, required this.course});

  @override
  State<_EnrollmentAction> createState() => _EnrollmentActionState();
}

class _EnrollmentActionState extends State<_EnrollmentAction> {
  bool _localPaid = false;
  bool _checkingLocalPurchase = true;

  @override
  void initState() {
    super.initState();
    _loadLocalPurchase();
  }

  Future<void> _loadLocalPurchase() async {
    final tokenStorage = getIt<TokenStorage>();
    final storage = getIt<EnrollmentStorage>();
    final userId = await tokenStorage.getUserId();
    if (userId == null || userId <= 0) {
      if (mounted) setState(() => _checkingLocalPurchase = false);
      return;
    }

    final paid = await storage.isCoursePaid(
      userId: userId,
      courseId: widget.courseId,
    );

    if (mounted) {
      setState(() {
        _localPaid = paid;
        _checkingLocalPurchase = false;
      });
    }
  }

  Future<void> _openFirstContent() async {
    final firstContent = _firstContent(widget.course);
    if (firstContent?.id == null) return;

    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ContentPage(
          courseId: widget.courseId,
          contentId: firstContent!.id!,
          title: firstContent.title,
          contentType: firstContent.contentType,
          description: firstContent.description,
          duration: firstContent.duration,
        ),
      ),
    );

    if (changed == true && mounted) {
      context.read<CourseInfoBloc>().add(
        GetCourseInfoEvent(id: widget.courseId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingLocalPurchase) {
      return const SizedBox(
        height: 52,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_localPaid) {
      return _ContinueButton(
        course: widget.course,
        onPressed: _openFirstContent,
      );
    }

    return BlocBuilder<CoursesEnrollmentBloc, CoursesEnrollmentState>(
      builder: (context, state) {
        if (state is CoursesEnrollmentLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CoursesEnrollmentError) {
          return _buildBuyFallback();
        }

        if (state is! CoursesEnrollmentLoaded) {
          return _buildBuyFallback();
        }

        final items = state.coursesEnrollmentModel.items ?? const <Items>[];
        Items? enrollment;
        for (final item in items) {
          if (item.id == widget.courseId) {
            enrollment = item;
            break;
          }
        }

        if (enrollment == null || enrollment.enrollmentId == null) {
          return SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EnrollPage(courseId: widget.courseId),
                  ),
                );
                if (!mounted) return;
                await _loadLocalPurchase();
                context.read<CourseInfoBloc>().add(
                  GetCourseInfoEvent(id: widget.courseId),
                );
                context.read<CoursesEnrollmentBloc>().add(
                  const GetCoursesEnrollmentEvent(unpaidOnly: false),
                );
              },
              icon: const Icon(Icons.school_outlined),
              label: const Text('Enroll in this course'),
            ),
          );
        }

        final status = enrollment.status?.trim().toLowerCase() ?? '';
        final unpaid =
            status.isEmpty ||
            status.contains('unpaid') ||
            status.contains('pending') ||
            status.contains('payment') ||
            status.contains('await');

        final paidByEnrollment = !unpaid && enrollment.enrollmentId! > 0;

        if (paidByEnrollment) {
          return _ContinueButton(
            course: widget.course,
            onPressed: _openFirstContent,
          );
        }

        if (unpaid) {
          return SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentPage(
                      courseId: widget.courseId,
                      enrollmentId: enrollment!.enrollmentId!,
                      amount: enrollment.price ?? widget.course.price ?? 0,
                    ),
                  ),
                );
                if (!mounted) return;
                await _loadLocalPurchase();
                context.read<CourseInfoBloc>().add(
                  GetCourseInfoEvent(id: widget.courseId),
                );
                context.read<CoursesEnrollmentBloc>().add(
                  const GetCoursesEnrollmentEvent(unpaidOnly: false),
                );
              },
              icon: const Icon(Icons.payment_outlined),
              label: Text(
                'Pay ${_formatPrice(enrollment.price ?? widget.course.price)}',
              ),
            ),
          );
        }

        return _ContinueButton(
          course: widget.course,
          onPressed: _openFirstContent,
        );
      },
    );
  }

  Widget _buildBuyFallback() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EnrollPage(courseId: widget.courseId),
            ),
          );
          if (!mounted) return;
          await _loadLocalPurchase();
          context.read<CourseInfoBloc>().add(
            GetCourseInfoEvent(id: widget.courseId),
          );
          context.read<CoursesEnrollmentBloc>().add(
            const GetCoursesEnrollmentEvent(unpaidOnly: false),
          );
        },
        icon: const Icon(Icons.shopping_cart_outlined),
        label: const Text('Buy / Enroll'),
      ),
    );
  }

}

Future<bool> _isLocallyPaid(int courseId) async {
  final tokenStorage = getIt<TokenStorage>();
  final storage = getIt<EnrollmentStorage>();
  final userId = await tokenStorage.getUserId();
  if (userId == null || userId <= 0) return false;
  return storage.isCoursePaid(userId: userId, courseId: courseId);
}

bool _hasPaidEnrollment(BuildContext context, int courseId) {
  final state = context.read<CoursesEnrollmentBloc>().state;
  if (state is! CoursesEnrollmentLoaded) return false;

  final items = state.coursesEnrollmentModel.items ?? const <Items>[];
  for (final item in items) {
    if (item.id != courseId) continue;
    final status = item.status?.trim().toLowerCase() ?? '';
    if (status.isEmpty ||
        status.contains('unpaid') ||
        status.contains('pending') ||
        status.contains('payment') ||
        status.contains('await')) {
      return false;
    }
    return item.enrollmentId != null;
  }
  return false;
}

Contents? _firstContent(CourseInfoModel value) {
  for (final section in value.sections ?? const <Sections>[]) {
    for (final content in section.contents ?? const <Contents>[]) {
      if (content.id != null) return content;
    }
  }
  return null;
}

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(child: Text(message)),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colors.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: colors.primary,
          size: 52,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
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
              color: colors.error,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
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

String _resolveImageUrl(String? value, int courseId) {
  final raw = value?.trim() ?? '';

  if (raw.isEmpty) {
    return '${ApiConfig.baseUrl}${ApiEndpoints.courseImage(courseId)}';
  }

  if (raw.startsWith('http://') || raw.startsWith('https://')) {
    return raw;
  }

  if (raw.startsWith('/')) {
    return '${ApiConfig.baseUrl}$raw';
  }

  return '${ApiConfig.baseUrl}/$raw';
}

String _formatPrice(double? value) {
  if (value == null) return 'Free';

  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }

  return value.toStringAsFixed(2);
}

class _ContinueButton extends StatelessWidget {
  final CourseInfoModel course;
  final VoidCallback onPressed;

  const _ContinueButton({required this.course, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final firstContent = _firstContent(course);
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: firstContent?.id == null ? null : onPressed,
        icon: const Icon(Icons.play_arrow_rounded),
        label: Text(
          firstContent == null ? 'No Content Yet' : 'Continue Learning',
        ),
      ),
    );
  }
}


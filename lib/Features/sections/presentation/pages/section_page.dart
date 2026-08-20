import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation2/Features/content/presentation/pages/content_page.dart';
import 'package:graduation2/Features/quiz/presentation/pages/quiz_page.dart';
import 'package:graduation2/Features/course_info/data/models/course_info_model.dart';
import 'package:graduation2/Features/course_info/presentation/manager/bloc/courseinfo_bloc.dart';
import 'package:graduation2/core/di/injection.dart';






class SectionPage extends StatelessWidget {
  final int id;

  const SectionPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CourseInfoBloc>()..add(GetCourseInfoEvent(id: id)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Course Content')),
        body: BlocBuilder<CourseInfoBloc, CourseInfoState>(
          builder: (context, state) {
            if (state is CourseInfoInitial || state is CourseInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CourseInfoError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => context.read<CourseInfoBloc>().add(
                  GetCourseInfoEvent(id: id),
                ),
              );
            }

            if (state is CourseInfoLoaded) {
              return _SectionsList(
                courseId: id,
                sections: state.courseInfoModel.sections ?? const <Sections>[],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _SectionsList extends StatelessWidget {
  final int courseId;
  final List<Sections> sections;

  const _SectionsList({required this.courseId, required this.sections});

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) {
      return Center(
        child: Text(
          'No sections available for this course.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final contents = section.contents ?? const <Contents>[];
        final completedCount =
            contents.where((content) => content.isCompleted == true).length;

        return Card(
          color: Theme.of(context).colorScheme.surface,
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            iconColor: Theme.of(context).colorScheme.primary,
            collapsedIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
            title: Text(
              '${index + 1}. ${_text(section.title, 'Section ${index + 1}')} ',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              contents.isEmpty
                  ? 'No lessons'
                  : '$completedCount/${contents.length} lessons completed',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            children: contents.isEmpty
                ? [
                    ListTile(
                      title: Text(
                        'No content available.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ]
                : [
                    for (
                      var contentIndex = 0;
                      contentIndex < contents.length;
                      contentIndex++
                    )
                      _ContentTile(
                        courseId: courseId,
                        content: contents[contentIndex],
                        index: contentIndex + 1,
                      ),
                    if (section.id != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonalIcon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuizPage(
                                  courseId: courseId,
                                  sectionId: section.id!,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.quiz_outlined),
                            label: const Text('Open Section Quiz'),
                          ),
                        ),
                      ),
                  ],
          ),
        );
      },
    );
  }
}

class _ContentTile extends StatelessWidget {
  final int courseId;
  final Contents content;
  final int index;

  const _ContentTile({
    required this.courseId,
    required this.content,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final contentId = content.id;
    final type = content.contentType?.toLowerCase() ?? '';

    return ListTile(
      enabled: contentId != null,
      leading: Icon(
        _iconFor(type),
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        _text(content.title, 'Content $index'),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: _contentSubtitle(context, content),
      trailing: contentId == null
          ? null
          : Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.primary,
            ),
      onTap: contentId == null
          ? null
          : () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => ContentPage(
                    courseId: courseId,
                    contentId: contentId,
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
    );
  }

  Widget? _contentSubtitle(BuildContext context, Contents value) {
    final parts = <String>[];
    final description = value.description?.trim() ?? '';
    if (description.isNotEmpty) parts.add(description);
    if (value.duration != null && value.duration! > 0) {
      parts.add('${value.duration} min');
    }
    if (parts.isEmpty) return null;
    return Text(
      parts.join(' • '),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  IconData _iconFor(String type) {
    if (type.contains('pdf')) return Icons.picture_as_pdf_outlined;
    if (type.contains('image')) return Icons.image_outlined;
    if (type.contains('text')) return Icons.article_outlined;
    if (type.contains('file') || type.contains('document')) {
      return Icons.insert_drive_file_outlined;
    }
    return Icons.play_circle_outline;
  }
}

String _text(String? value, String fallback) {
  final text = value?.trim() ?? '';
  return text.isEmpty ? fallback : text;
}

Widget? _optionalText(BuildContext context, String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return null;
  return Text(
    text,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: Theme.of(context).textTheme.bodySmall,
  );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
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

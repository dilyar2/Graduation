import 'package:graduation2/Features/course_info/data/models/course_info_model.dart';

class CourseProgress {
  final int progress;
  final int completed;
  final int total;
  final bool isCompleted;

  const CourseProgress({
    required this.progress,
    required this.completed,
    required this.total,
    required this.isCompleted,
  });

  factory CourseProgress.fromCourse(CourseInfoModel course) {
    final sections = course.sections ?? const <Sections>[];
    var total = 0;
    var completed = 0;

    for (final section in sections) {
      final contents = section.contents ?? const <Contents>[];
      total += contents.length;
      completed += contents.where((content) => content.isCompleted == true).length;
    }

    if (total == 0) {
      final apiTotal = course.totalContents ?? 0;
      final apiCompleted = course.completedContents ?? 0;
      final apiProgress = (course.progress ?? 0).clamp(0, 100).toInt();
      final completedState = course.isCompleted == true ||
          (apiTotal > 0 && apiCompleted >= apiTotal);
      return CourseProgress(
        progress: apiProgress,
        completed: apiCompleted,
        total: apiTotal,
        isCompleted: completedState,
      );
    }

    final value = ((completed / total) * 100).round().clamp(0, 100);
    return CourseProgress(
      progress: value,
      completed: completed,
      total: total,
      isCompleted: completed == total,
    );
  }
}

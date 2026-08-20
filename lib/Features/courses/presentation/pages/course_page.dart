import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/courses/presentation/manager/bloc/courses_category_bloc.dart';
import 'package:graduation2/Features/courses/presentation/widgets/custom_course_card.dart';
import 'package:graduation2/Features/course_info/presentation/pages/course_details_page.dart';
import 'package:graduation2/core/di/injection.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({
    super.key,
    required this.category,
    required this.categoryName,
  });

  final String category;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CourseBloc>()
        ..add(GetCoursesByCategoryEvent(category: category)),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(categoryName),
            actions: [
              IconButton(
                tooltip: 'Refresh',
                onPressed: () => context.read<CourseBloc>().add(
                      GetCoursesByCategoryEvent(category: category),
                    ),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: BlocBuilder<CourseBloc, CourseState>(
            builder: (context, state) {
              if (state is CourseLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CourseError) {
                return _ErrorView(
                  message: state.message,
                  onRetry: () => context.read<CourseBloc>().add(
                        GetCoursesByCategoryEvent(category: category),
                      ),
                );
              }

              if (state is CourseLoaded) {
                final courses = state.courses.items;

                if (courses.isEmpty) {
                  return Center(
                    child: Text(
                      'No courses found in "$categoryName"',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<CourseBloc>().add(
                          GetCoursesByCategoryEvent(category: category),
                        );
                    await Future<void>.delayed(
                      const Duration(milliseconds: 300),
                    );
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 420,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 330,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];

                      return CustomCourseCard(
                        image: course.imageUrl,
                        courseName: course.slug ?? course.title ?? 'Course',
                        description: course.description ?? '',
                        rating: course.averageRating ?? 0,
                        watchCount: course.watchCount ?? 0,
                        title: course.title ?? 'Course',
                        price: course.price,
                        onTap: course.id == null
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetailsPage(
                                      courseId: course.id!,
                                    ),
                                  ),
                                );
                              },
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
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

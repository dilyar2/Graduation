import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/categories/presentation/manager/bloc/category_bloc.dart';
import 'package:graduation2/Features/categories/presentation/widgets/custom_category_card.dart';
import 'package:graduation2/Features/courses/presentation/pages/course_page.dart';
import 'package:graduation2/Features/search/presentaion/widgets/custom_search_widget.dart';
import 'package:graduation2/Features/teacher/presentation/manager/bloc/teacher_bloc.dart';
import 'package:graduation2/Features/teacher/presentation/widgets/card_of_teacher.dart';
import 'package:graduation2/app_router.dart';
import 'package:graduation2/core/constant/theme_app.dart';
import 'package:graduation2/core/di/injection.dart';
import 'package:graduation2/core/theme/theme_toggle_button.dart';
import 'package:graduation2/Features/teacher/presentation/pages/teachers_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<TeacherBloc>()..add(GetTeachersEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<CategoryBloc>()..add(GetAllCategoriesEvent()),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<CategoryBloc>().add(GetAllCategoriesEvent());
          context.read<TeacherBloc>().add(GetTeachersEvent());
          await Future<void>.delayed(const Duration(milliseconds: 400));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'GRADUATION',
                            style: context.appTypography.special.copyWith(
                              fontSize: 13,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                        const ThemeToggleButton(),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Learn. Grow. Achieve.',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find the right course and instructor for you.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    const CustomSearchWidget(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: _sectionHeader(context, 'Categories')),
            SliverToBoxAdapter(child: _categories(context)),
            SliverToBoxAdapter(
              child: _sectionHeader(context, 'Instructors', showAction: true),
            ),
            SliverToBoxAdapter(child: _teachers(context)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.primary.withValues(alpha: .16),
                        colors.secondary.withValues(alpha: .10),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: .22),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: colors.primary,
                        size: 30,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Keep learning and build your next skill.',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    String title, {
    bool showAction = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          if (showAction)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TeachersPage()),
                );
              },
              child: const Text('View all'),
            ),
        ],
      ),
    );
  }

  Widget _categories(BuildContext context) {
    return SizedBox(
      height: 82,
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading)
            return const Center(child: CircularProgressIndicator());
          if (state is CategoryFailed)
            return _ErrorInline(message: state.message.toString());
          if (state is CategoryLoaded) {
            if (state.categoryModel.isEmpty)
              return const _EmptyInline(message: 'No categories available');
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: state.categoryModel.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, index) {
                final category = state.categoryModel[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap:
                      (category.name == null || category.name!.trim().isEmpty)
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CoursePage(
                              category: category.name ?? '',
                              categoryName: category.name ?? 'Courses',
                            ),
                          ),
                        ),
                  child: CustomCategoryCard(
                    category: category.name ?? 'Category',
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _teachers(BuildContext context) {
    return SizedBox(
      height: 220,
      child: BlocBuilder<TeacherBloc, TeacherState>(
        builder: (context, state) {
          if (state is TeacherLoading)
            return const Center(child: CircularProgressIndicator());
          if (state is TeacherError)
            return _ErrorInline(message: state.message);
          if (state is TeacherLoaded) {
            if (state.teachers.isEmpty)
              return const _EmptyInline(message: 'No instructors available');
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: state.teachers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                final teacher = state.teachers[index];
                final image = state.image[teacher.userId] ?? Uint8List(0);
                return CardOfTeacher(
                  id: teacher.userId ?? 0,
                  firstName: teacher.firstName ?? '',
                  lastName: teacher.lastName ?? '',
                  specialization: teacher.specialization ?? '',
                  rating: teacher.averageRating ?? 0,
                  bio: teacher.bio ?? '',
                  views: teacher.viewCount ?? 0,
                  image: image,
                  onTap: teacher.userId == null
                      ? null
                      : () => Navigator.pushNamed(
                          context,
                          AppRouter.teacherDetails,
                          arguments: {'teacher': teacher, 'image': image},
                        ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _EmptyInline extends StatelessWidget {
  final String message;
  const _EmptyInline({required this.message});
  @override
  Widget build(BuildContext context) => Center(
    child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
  );
}

class _ErrorInline extends StatelessWidget {
  final String message;
  const _ErrorInline({required this.message});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ),
  );
}

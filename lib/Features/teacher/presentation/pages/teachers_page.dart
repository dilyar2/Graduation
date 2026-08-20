import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/teacher/presentation/manager/bloc/teacher_bloc.dart';
import 'package:graduation2/Features/teacher/presentation/widgets/card_of_teacher.dart';
import 'package:graduation2/app_router.dart';
import 'package:graduation2/core/di/injection.dart';

class TeachersPage extends StatelessWidget {
  const TeachersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TeacherBloc>()..add(const GetTeachersEvent()),
      child: const _TeachersView(),
    );
  }
}

class _TeachersView extends StatelessWidget {
  const _TeachersView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Instructors')),
      body: BlocBuilder<TeacherBloc, TeacherState>(
        builder: (context, state) {
          if (state is TeacherLoading || state is TeacherInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TeacherError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off_rounded,
                        size: 48, color: colors.primary),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => context
                          .read<TeacherBloc>()
                          .add(const GetTeachersEvent()),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is TeacherLoaded) {
            if (state.teachers.isEmpty) {
              return const Center(child: Text('No instructors available'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<TeacherBloc>()
                    .add(const GetTeachersEvent());
                await Future<void>.delayed(const Duration(milliseconds: 350));
              },
              child: GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 360,
                  mainAxisExtent: 235,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: state.teachers.length,
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
                              arguments: {
                                'teacher': teacher,
                                'image': image,
                              },
                            ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

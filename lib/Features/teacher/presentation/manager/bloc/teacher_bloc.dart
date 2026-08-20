import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/teacher/data/models/teacher_model.dart';
import 'package:graduation2/Features/teacher/domain/usecases/get_all_teaches_usecase.dart';
import 'package:graduation2/Features/teacher/domain/usecases/get_teacher_img_usecase.dart';
import 'package:injectable/injectable.dart';

part 'teacher_event.dart';
part 'teacher_state.dart';

@injectable
class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final GetAllTeachesUsecase getAllTeachersUseCase;
  final GetTeacherImgUsecase getTeacherImageUseCase;

  TeacherBloc(
    this.getAllTeachersUseCase,
    this.getTeacherImageUseCase,
  ) : super(TeacherInitial()) {
    on<GetTeachersEvent>((event, emit) async {
      emit(TeacherLoading());

      try {
        final result = await getAllTeachersUseCase(
          orderBy: event.orderBy,
        );

        await result.fold(
          (failure) async {
            emit(TeacherError(message: failure.message));
          },
          (teachers) async {
            final Map<int, Uint8List> images = {};

            for (final teacher in teachers) {
              try {
                final image = await getTeacherImageUseCase(
                  teacher.userId!,
                );

                images[teacher.userId!] = image;
              } catch (_) {}
            }

            emit(
              TeacherLoaded(
                teachers: teachers,
                image: images,
              ),
            );
          },
        );
      } catch (e) {
        emit(
          TeacherError(
            message: e.toString(),
          ),
        );
      }
    });
  }
}

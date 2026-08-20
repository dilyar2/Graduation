import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/sections/data/models/section_model.dart';
import 'package:graduation2/Features/sections/domain/usecases/get_section_usecase.dart';
import 'package:injectable/injectable.dart';

part 'section_event.dart';
part 'section_state.dart';
@injectable
class SectionBloc extends Bloc<SectionEvent, SectionState> {
  final GetSectionUsecase getSectionUsecase;
  SectionBloc({required this.getSectionUsecase}) : super(SectionInitial()) {
    on<GetSectionByCourseEvent>((event, emit) async {
      emit(SectionLoading());
      final result = await getSectionUsecase(id: event.id);
      result.fold(
        (failure) {
          emit(SectionError(message: failure.message));
        },
        (sections) {
          emit(SectionLoaded(sectionModel: sections));
        },
      );
    });
  }
}

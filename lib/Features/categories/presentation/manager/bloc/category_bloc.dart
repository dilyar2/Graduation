import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/categories/data/models/category_model.dart';
import 'package:graduation2/Features/categories/domain/repositories/category_repo.dart';
import 'package:injectable/injectable.dart';

part 'category_event.dart';
part 'category_state.dart';
@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepo categoryRepo;
  CategoryBloc(this.categoryRepo) : super(CategoryInitial()) {
    on<GetAllCategoriesEvent>((event, emit) async {
      emit(CategoryLoading());

      final data = await categoryRepo.getAllCategory();
      data.fold(
        (failure) => emit(CategoryFailed(message: failure.message)),
        (success) => emit(CategoryLoaded(categoryModel: success)),
      );
    });


  }
}

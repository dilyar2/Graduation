part of 'category_bloc.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categoryModel;
  CategoryLoaded({required this.categoryModel});
}

class CategoryDetailsLoaded extends CategoryState {
  final CategoryModel categoryModel;

  CategoryDetailsLoaded({required this.categoryModel});
}

class CategoryFailed extends CategoryState {
  final String message;
  CategoryFailed({required this.message});
}

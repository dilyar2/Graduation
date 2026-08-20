import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/categories/data/models/category_model.dart';
import 'package:graduation2/Features/categories/domain/repositories/category_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetAllCategoriesUseCase {
  final CategoryRepo categoryRepo;

  GetAllCategoriesUseCase({required this.categoryRepo});
  Future<Either<Failure, List<CategoryModel>>> call() {
    return categoryRepo.getAllCategory();
  }
}

import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/categories/data/models/category_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class CategoryRepo {
  Future<Either<Failure,List< CategoryModel>>> getAllCategory();
}

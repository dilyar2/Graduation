import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/Profile/data/models/profile_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileModel>> getProfile();
}

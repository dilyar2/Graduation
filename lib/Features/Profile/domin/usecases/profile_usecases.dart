import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/Profile/domin/repo/profile_repo.dart';
import 'package:graduation2/Features/Profile/data/models/profile_model.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfileUseCase {
  final ProfileRepo profileRepo;

  GetProfileUseCase({required this.profileRepo});

  Future<Either<Failure, ProfileModel>> call() {
    return profileRepo.getProfile();
  }
}

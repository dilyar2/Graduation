import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/Profile/data/data_source/profile_data_source.dart';
import 'package:graduation2/Features/Profile/domin/repo/profile_repo.dart';
import 'package:graduation2/Features/Profile/data/models/profile_model.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource profileDataSource;

  ProfileRepoImpl({required this.profileDataSource});

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      final result = await profileDataSource.getProfile();

      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to get profile'),
      );
    } catch (e) {
      return Left(
        ServerFailure('Unexpected error while getting profile: $e'),
      );
    }
  }
}

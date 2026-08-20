import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/authentication/data/models/register_request_model.dart';
import 'package:graduation2/Features/authentication/data/models/register_response_model.dart';
import 'package:graduation2/Features/authentication/domain/repositories/auth_repo.dart';
import 'package:graduation2/core/error/failure.dart';


import 'package:injectable/injectable.dart';
@injectable
class RegisterUseCase {
  final AuthRepo authRepo;

  RegisterUseCase({required this.authRepo});
  Future<Either<Failure, RegisterResponseModel>> call(
    RegisterRequestModel registeRequestModel,
  ) async {
    return await authRepo.register(registeRequestModel);
  }
}

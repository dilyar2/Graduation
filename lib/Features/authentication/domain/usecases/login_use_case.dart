import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/authentication/data/models/login_request_model.dart';
import 'package:graduation2/Features/authentication/data/models/login_response_model.dart';
import 'package:graduation2/Features/authentication/domain/repositories/auth_repo.dart';
import 'package:graduation2/core/error/failure.dart';

import 'package:injectable/injectable.dart';
@injectable
class LoginUseCase {
final AuthRepo authRepo;

  LoginUseCase({required this.authRepo});

   Future<Either<Failure, LoginResponseModel>> call(
    LoginRequestModel request,
  ) async {
    return await authRepo.login(request);
  }
}

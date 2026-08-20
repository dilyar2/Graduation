import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/authentication/data/models/login_request_model.dart';
import 'package:graduation2/Features/authentication/data/models/login_response_model.dart';
import 'package:graduation2/Features/authentication/data/models/register_request_model.dart';
import 'package:graduation2/Features/authentication/data/models/register_response_model.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class AuthRepo {
  Future<Either<Failure, RegisterResponseModel>> register(
    RegisterRequestModel registerRequestModel,
  );

  Future<Either<Failure, LoginResponseModel>> login(
    LoginRequestModel loginRequestModel,
  );

  Future<Either<Failure, int>> getCurrentUserId();

  Future<Either<Failure, void>> logout();
}

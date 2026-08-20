import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/authentication/data/datasource/auth_data_source.dart';
import 'package:graduation2/Features/authentication/data/models/login_request_model.dart';
import 'package:graduation2/Features/authentication/data/models/login_response_model.dart';
import 'package:graduation2/Features/authentication/data/models/register_request_model.dart';
import 'package:graduation2/Features/authentication/data/models/register_response_model.dart';
import 'package:graduation2/Features/authentication/domain/repositories/auth_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource authDataSource;

  AuthRepoImpl({required this.authDataSource});

  @override
  Future<Either<Failure, RegisterResponseModel>> register(
    RegisterRequestModel request,
  ) async {
    try {
      return Right(await authDataSource.register(request));
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> login(
    LoginRequestModel request,
  ) async {
    try {
      return Right(await authDataSource.login(request));
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getCurrentUserId() async {
    try {
      return Right(await authDataSource.getCurrentUserId());
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authDataSource.logout();
      return const Right<Failure, void>(null);
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _mapDioFailure(DioException error) {
    final data = error.response?.data;
    String? message;

    if (data is Map) {
      final value = data['message'] ?? data['title'] ?? data['detail'];
      if (value is String && value.trim().isNotEmpty) {
        message = value;
      }
    } else if (data is String && data.trim().isNotEmpty) {
      message = data;
    }

    message ??= error.message;

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        NetworkFailure(message ?? 'Network error occurred'),
      _ => ServerFailure(message ?? 'Server request failed'),
    };
  }
}

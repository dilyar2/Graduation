import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/authentication/data/models/login_request_model.dart';
import 'package:graduation2/Features/authentication/data/models/register_request_model.dart';
import 'package:graduation2/Features/authentication/data/models/register_response_model.dart';
import 'package:graduation2/Features/authentication/domain/repositories/auth_repo.dart';
import 'package:graduation2/Features/authentication/domain/usecases/login_use_case.dart';
import 'package:graduation2/Features/authentication/domain/usecases/register_use_case.dart';
import 'package:graduation2/core/storage/token_storage.dart';
import 'package:graduation2/core/storage/enrollment_storage.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final AuthRepo authRepo;
  final TokenStorage tokenStorage;
  final EnrollmentStorage enrollmentStorage;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.authRepo,
    required this.tokenStorage,
    required this.enrollmentStorage,
  }) : super(AuthInitial()) {
    on<RegisterRequestedEvent>(_register);
    on<LoginRequestedEvent>(_login);
    on<LogoutRequested>(_logout);
  }

  Future<void> _register(
    RegisterRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final registerResult = await registerUseCase(event.request);
    await registerResult.fold<Future<void>>(
      (failure) async => emit(AuthFailure(message: failure.message)),
      (response) async {
        final registerId = response.id;
        if (registerId != null && registerId > 0) {
          await tokenStorage.saveUserId(registerId);
        }

        emit(RegisterSuccess(registerResponseModel: response));



        await _performLogin(
          LoginRequestModel(
            email: event.request.email,
            password: event.request.password,
          ),
          emit,
        );
      },
    );
  }

  Future<void> _login(
    LoginRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _performLogin(event.request, emit);
  }

  Future<void> _performLogin(
    LoginRequestModel request,
    Emitter<AuthState> emit,
  ) async {
    final result = await loginUseCase(request);

    await result.fold<Future<void>>(
      (failure) async {
        await tokenStorage.clearTokens();
        emit(AuthFailure(message: failure.message));
      },
      (response) async {
        final token = response.token;
        final refreshToken = response.refreshToken;

        if (token == null || token.isEmpty ||
            refreshToken == null || refreshToken.isEmpty) {
          await tokenStorage.clearTokens();
          emit(AuthFailure(message: 'Login response is missing token data'));
          return;
        }

        await tokenStorage.saveAccessToken(
          token,
          expiresInMinutes: response.expiresInMinutes,
        );
        await tokenStorage.saveRefreshToken(refreshToken);




        final userIdResult = await authRepo.getCurrentUserId();

        await userIdResult.fold<Future<void>>(
          (failure) async {
            await tokenStorage.clearTokens();
            emit(AuthFailure(message: failure.message));
          },
          (userId) async {
            await tokenStorage.saveUserId(userId);
            emit(
              Authenticated(
                token: token,
                refreshToken: refreshToken,
                userId: userId,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _logout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());



    final userId = await tokenStorage.getUserId();
    final hasSession = await tokenStorage.hasSession();
    if (hasSession) {
      await authRepo.logout();
    }
    if (userId != null && userId > 0) {
      await enrollmentStorage.clearUserPurchases(userId);
    }
    await tokenStorage.clearTokens();



    emit(Unauthenticated());
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/app_router.dart';
import 'package:graduation2/Features/authentication/presentation/pages/manager/bloc/auth_bloc.dart';
import 'package:graduation2/core/constant/theme_app.dart';
import 'package:graduation2/core/di/injection.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:graduation2/core/storage/token_storage.dart';
import 'package:graduation2/core/storage/enrollment_storage.dart';
import 'package:graduation2/core/storage/theme_storage.dart';
import 'package:graduation2/core/theme/theme_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await configureDependencies();

  final tokenStorage = getIt<TokenStorage>();
  await tokenStorage.init();

  final enrollmentStorage = getIt<EnrollmentStorage>();
  await enrollmentStorage.init();

  final themeStorage = ThemeStorage();
  await themeStorage.init();
  final themeController = ThemeController(storage: themeStorage);
  await themeController.init();

  final initialRoute = await _resolveInitialRoute(tokenStorage);

  runApp(
    MyApp(
      initialRoute: initialRoute,
      themeController: themeController,
    ),
  );
}

Future<String> _resolveInitialRoute(TokenStorage tokenStorage) async {
  if (!await tokenStorage.hasSession()) {
    return AppRouter.login;
  }

  try {
    final response = await getIt<DioClient>().dio.get(ApiEndpoints.meInfo);
    final data = response.data;

    if (data is Map) {
      final rawId = data['id'];
      final userId = rawId is int
          ? rawId
          : (rawId is num ? rawId.toInt() : null);
      if (userId != null && userId > 0) {
        await tokenStorage.saveUserId(userId);
      }
    }




    return AppRouter.home;
  } on DioException {



    return await tokenStorage.hasSession()
        ? AppRouter.home
        : AppRouter.login;
  } catch (_) {
    return await tokenStorage.hasSession()
        ? AppRouter.home
        : AppRouter.login;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.initialRoute,
    required this.themeController,
  });

  final String initialRoute;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => getIt<AuthBloc>(),
      child: ThemeControllerScope(
        controller: themeController,
        child: ListenableBuilder(
          listenable: themeController,
          builder: (context, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Graduation App',
              initialRoute: initialRoute,
              onGenerateRoute: AppRouter.onGenerateRoute,
              theme: ThemeApp.light,
              darkTheme: ThemeApp.dark,
              themeMode: themeController.themeMode,
            );
          },
        ),
      ),
    );
  }
}

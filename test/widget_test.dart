import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:graduation2/app_router.dart';
import 'package:graduation2/core/di/injection.dart';
import 'package:graduation2/core/storage/theme_storage.dart';
import 'package:graduation2/core/storage/token_storage.dart';
import 'package:graduation2/core/theme/theme_controller.dart';
import 'package:graduation2/main.dart';
import 'package:hive/hive.dart';

void main() {
  late ThemeController themeController;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final tempDir = Directory.systemTemp.createTempSync('graduation2_test_');

    Hive.init(tempDir.path);

    await configureDependencies();

    await getIt<TokenStorage>().init();

    final themeStorage = ThemeStorage();
    await themeStorage.init();

    themeController = ThemeController(storage: themeStorage);

    await themeController.init();
  });

  tearDownAll(() {
    themeController.dispose();
  });

  testWidgets('App launches login route', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(initialRoute: AppRouter.login, themeController: themeController),
    );

    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
  });
}

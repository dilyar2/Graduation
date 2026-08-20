import 'package:flutter/material.dart';
import 'package:graduation2/core/storage/theme_storage.dart';

class ThemeController extends ChangeNotifier {
  final ThemeStorage storage;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeController({required this.storage});

  ThemeMode get themeMode => _themeMode;

  bool get isSystem => _themeMode == ThemeMode.system;

  Future<void> init() async {
    final saved = storage.getThemeMode();

    switch (saved) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();
    await storage.saveThemeMode(_modeName(mode));
  }

  Future<void> toggle({required bool currentlyDark}) async {
    await setTheme(
      currentlyDark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  String _modeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

class ThemeControllerScope extends InheritedNotifier<ThemeController> {
  const ThemeControllerScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ThemeControllerScope>();

    assert(scope != null, 'ThemeControllerScope is missing above this context.');
    return scope!.notifier!;
  }
}

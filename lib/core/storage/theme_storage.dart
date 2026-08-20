import 'package:hive/hive.dart';

class ThemeStorage {
  static const String _boxName = 'settingsBox';
  static const String _themeKey = 'theme_mode';

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  String? getThemeMode() {
    if (!Hive.isBoxOpen(_boxName)) return null;
    final value = Hive.box(_boxName).get(_themeKey);
    return value is String ? value : null;
  }

  Future<void> saveThemeMode(String value) async {
    final box = Hive.isBoxOpen(_boxName)
        ? Hive.box(_boxName)
        : await Hive.openBox(_boxName);
    await box.put(_themeKey, value);
  }
}

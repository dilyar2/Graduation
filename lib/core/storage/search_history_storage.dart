import 'package:hive/hive.dart';

class SearchHistoryStorage {
  static const _boxName = 'searchHistoryBox';
  static const _hiddenRecentKey = 'hidden_recent_searches';

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  Set<String> getHiddenRecent() {
    if (!Hive.isBoxOpen(_boxName)) return <String>{};
    final value = Hive.box(_boxName).get(_hiddenRecentKey);
    if (value is! List) return <String>{};
    return value
        .whereType<String>()
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();
  }

  Future<void> hideRecent(String query) async {
    final hidden = getHiddenRecent();
    hidden.add(query.trim().toLowerCase());
    await Hive.box(_boxName).put(_hiddenRecentKey, hidden.toList());
  }

  Future<void> unhideRecent(String query) async {
    final hidden = getHiddenRecent();
    hidden.remove(query.trim().toLowerCase());
    await Hive.box(_boxName).put(_hiddenRecentKey, hidden.toList());
  }
}

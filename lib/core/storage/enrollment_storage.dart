import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class EnrollmentStorage {
  static const _boxName = 'enrollmentBox';
  static const _paidCoursesKey = 'paid_courses_by_user';

  late Box box;

  Future<void> init() async {
    if (Hive.isBoxOpen(_boxName)) {
      box = Hive.box(_boxName);
      return;
    }
    box = await Hive.openBox(_boxName);
  }

  Future<void> markCoursePaid({required int userId, required int courseId}) async {
    final all = _readAll();
    final ids = all[userId.toString()] ?? <int>[];
    if (!ids.contains(courseId)) {
      ids.add(courseId);
      all[userId.toString()] = ids;
      await box.put(_paidCoursesKey, all);
    }
  }

  Future<bool> isCoursePaid({required int userId, required int courseId}) async {
    final ids = _readAll()[userId.toString()] ?? <int>[];
    return ids.contains(courseId);
  }

  Future<void> clearUserPurchases(int userId) async {
    final all = _readAll();
    all.remove(userId.toString());
    await box.put(_paidCoursesKey, all);
  }

  Map<String, List<int>> _readAll() {
    final stored = box.get(_paidCoursesKey);
    if (stored is Map) {
      final result = <String, List<int>>{};
      for (final entry in stored.entries) {
        final key = entry.key.toString();
        final value = entry.value;
        if (value is List) {
          result[key] = value
              .whereType<num>()
              .map((e) => e.toInt())
              .toList();
        }
      }
      return result;
    }




    return <String, List<int>>{};
  }
}

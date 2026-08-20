import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TokenStorage {
  static const _boxName = 'authBox';
  static const _settingsBoxName = 'settingsBox';
  static const _encryptionKey = 'hive_encryption_key';
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _accessTokenExpiresAtKey = 'access_token_expires_at';

  late final Box box;

  Future<void> init() async {
    final settingsBox = await Hive.openBox(_settingsBoxName);
    final List<int> encryptionKey;
    final storedKey = settingsBox.get(_encryptionKey);

    if (storedKey is List) {
      encryptionKey = List<int>.from(storedKey);
    } else {
      encryptionKey = Hive.generateSecureKey();
      await settingsBox.put(_encryptionKey, encryptionKey);
    }

    box = await Hive.openBox(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  Future<void> saveAccessToken(
    String token, {
    int? expiresInMinutes,
  }) async {
    await box.put(_accessTokenKey, token);
    if (expiresInMinutes != null && expiresInMinutes > 0) {
      final expiresAt = DateTime.now()
          .add(Duration(minutes: expiresInMinutes))
          .millisecondsSinceEpoch;
      await box.put(_accessTokenExpiresAtKey, expiresAt);
    } else {
      await box.delete(_accessTokenExpiresAtKey);
    }
  }

  Future<String?> getAccessToken() async {
    final value = box.get(_accessTokenKey);
    return value is String && value.isNotEmpty ? value : null;
  }

  Future<bool> isAccessTokenExpired({
    Duration safetyWindow = const Duration(seconds: 30),
  }) async {
    final token = await getAccessToken();
    if (token == null) return true;

    final rawExpiry = box.get(_accessTokenExpiresAtKey);
    if (rawExpiry is! int) return false;

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(rawExpiry);
    return DateTime.now().add(safetyWindow).isAfter(expiresAt);
  }

  Future<void> saveRefreshToken(String token) async {
    await box.put(_refreshTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    final value = box.get(_refreshTokenKey);
    return value is String && value.isNotEmpty ? value : null;
  }

  Future<void> saveUserId(int id) async {
    await box.put(_userIdKey, id);
  }

  Future<int?> getUserId() async {
    final value = box.get(_userIdKey);
    return value is int ? value : null;
  }

  Future<bool> hasSession() async {
    final access = await getAccessToken();
    final refresh = await getRefreshToken();
    final userId = await getUserId();
    return access != null && refresh != null && userId != null && userId > 0;
  }

  Future<void> deleteAccessToken() async {
    await box.delete(_accessTokenKey);
    await box.delete(_accessTokenExpiresAtKey);
  }

  Future<void> clearTokens() async {
    await box.delete(_accessTokenKey);
    await box.delete(_refreshTokenKey);
    await box.delete(_userIdKey);
    await box.delete(_accessTokenExpiresAtKey);
  }
}

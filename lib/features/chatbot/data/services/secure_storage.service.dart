import 'package:dellight/env.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accountName: EnvConfig.ACCOUNT_NAME,
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Future<void> writeToken(String token) async {
    await _storage.write(
      key: 'auth_token',
      value: token,
    );
  }

  Future<void> writeRefreshToken(String refreshToken) async {
    await _storage.write(
      key: 'refresh_token',
      value: refreshToken,
    );
  }

  Future<String?> readToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<String?> readRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'refresh_token');
  }
}

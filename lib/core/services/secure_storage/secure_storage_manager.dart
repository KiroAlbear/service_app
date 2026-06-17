import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  static SecureStorageManager? _instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static SecureStorageManager getInstance() {
    return _instance ??= SecureStorageManager();
  }

  Future<void> setValue(String key, String? value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getValue(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> setObject(String key, Object? object) async {
    await setValue(key, object == null ? null : jsonEncode(object));
  }

  Future<T?> getObjects<T>(
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final String? value = await getValue(key);
    if (value == null || value.isEmpty) {
      return null;
    }

    final dynamic decodedValue = jsonDecode(value);
    if (decodedValue is! Map<String, dynamic>) {
      return null;
    }

    return fromJson(decodedValue);
  }

  Future<void> deleteValue(String key) async {
    return await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}

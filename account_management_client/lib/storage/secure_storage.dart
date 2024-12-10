import 'package:account_management_client/storage/storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage implements Storage {

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }
  
  @override
  Future<dynamic> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }

}
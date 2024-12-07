abstract class Storage {
  Future<void> write(String key, String value);
  Future<dynamic> read(String key);
  Future<void> delete(String key);
  Future<void> clear();
}
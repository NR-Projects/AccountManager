class AppGlobalStore {
  static final AppGlobalStore _singleton = AppGlobalStore._internal();
  factory AppGlobalStore() {
    return _singleton;
  }
  AppGlobalStore._internal();
  
  // Declare global props
  String? _token;

  // Declare getters and setters
  void setToken(String token) => _token = token;
  bool isAuthenticated() => _token != null;
  String? getToken() => _token;
  void clearToken() => _token = null;
}
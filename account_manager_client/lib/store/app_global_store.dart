

class AppGlobalStore {
  static final AppGlobalStore _singleton = AppGlobalStore._internal();
  factory AppGlobalStore() {
    return _singleton;
  }
  AppGlobalStore._internal();
  
  // Declare global props
  String? _token;
  String? _role;

  // Declare getters and setters
  void setToken(String token, String role) {
    _token = token;
    _role = role;
  }
  bool isAuthenticated() => _token != null;
  String? getToken() => _token;
  String? getRole() => _role;
  void clearToken() => _token = null;
}


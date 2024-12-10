import 'package:account_management_client/model/entity/user_device.dart';

class AppGlobalStore {
  static final AppGlobalStore _singleton = AppGlobalStore._internal();
  factory AppGlobalStore() {
    return _singleton;
  }
  AppGlobalStore._internal();
  
  // Declare global props
  String? _token;
  UserDevice? _userDevice;

  // Token
  void setToken(String token, UserDevice userDevice) {
    _token = token;
    _userDevice = userDevice;
  }
  bool isAuthenticated() => _token != null;
  String? getToken() => _token;
  UserDevice? getUserDevice() => _userDevice;
  void removeAuthentication() {
    _token = null;
    _userDevice = null;
  }
}
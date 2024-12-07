// lib/constants/api_constants.dart

// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, camel_case_types

class API_ {
  final String _baseUrl = const String.fromEnvironment('SERVER_ENDPOINT');

  // User endpoints and constants
  late _User User = _User(_baseUrl);
  late _Auth Auth = _Auth(_baseUrl);
  late _ServerConfig ServerConfig = _ServerConfig(_baseUrl);

}

class _User {
  final String baseUrl;
  late String apiPrefix = "$baseUrl/user";

  _User(this.baseUrl);

  String get REGISTER_USER_DEVICE => "$apiPrefix/register-device";
  String get ALL_USERS => "$apiPrefix/all";
  String get UPDATE_USER => apiPrefix;
  String get DELETE_USER => apiPrefix;
}

class _Auth {
  final String baseUrl;
  late String apiPrefix = "$baseUrl/auth";

  _Auth(this.baseUrl);

  String get LOGIN => "$apiPrefix/login";
}

class _ServerConfig {
  final String baseUrl;
  late String apiPrefix = "$baseUrl/server-config";

  _ServerConfig(this.baseUrl);

  String get ADD_REGISTER_SECRET => "$apiPrefix/add-register-secret";
  String get ENABLE_GUEST_REQUESTS => "$apiPrefix/enable-guest-requests";
  String get DISABLE_GUEST_REQUESTS => "$apiPrefix/disable-guest-requests";
  String get GET_SERVER_CONFIG => apiPrefix;
  String get CHANGE_MASTER_PASSWORD => "$apiPrefix/change-master-password";
  String get CLEAR_DATA => "$apiPrefix/clear-data";
}

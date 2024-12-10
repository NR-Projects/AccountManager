// lib/constants/api_constants.dart

// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, camel_case_types

class API_ {
  final String _baseUrl = const String.fromEnvironment('SERVER_ENDPOINT');

  // User endpoints and constants
  late _UserDevice UserDevice = _UserDevice(_baseUrl);
  late _Auth Auth = _Auth(_baseUrl);
  late _ServerConfig ServerConfig = _ServerConfig(_baseUrl);
  late _Site Site = _Site(_baseUrl);
  late _Account Account = _Account(_baseUrl);

}

class _UserDevice {
  final String baseUrl;
  late String apiPrefix = "$baseUrl/user-device";

  _UserDevice(this.baseUrl);

  String get REGISTER_USER_DEVICE => "$apiPrefix/register";
  String get GET_SELF => apiPrefix;
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

class _Site {
  final String baseUrl;
  late String apiPrefix = "$baseUrl/site";

  _Site(this.baseUrl);

  String get CREATE_SITE => apiPrefix;
  String get GET_ALL_SITES => "$apiPrefix/all";
  String get UPDATE_SITE => apiPrefix;
  String get DELETE_SITE => apiPrefix;
}


class _Account {
  final String baseUrl;
  late String apiPrefix = "$baseUrl/account";

  _Account(this.baseUrl);

  String get CREATE_ACCOUNT => apiPrefix;
  String get GET_ALL_ACCOUNTS => "$apiPrefix/all";
  String get GET_ACCOUNT_PASSWORD => "$apiPrefix/password";
  String get UPDATE_ACCOUNT => apiPrefix;
  String get DELETE_ACCOUNT => apiPrefix;
}
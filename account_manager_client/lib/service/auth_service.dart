import 'dart:convert';

import 'package:account_manager_client/service/base_service.dart';
import 'package:account_manager_client/service/device_service.dart';
import 'package:account_manager_client/storage/storage.dart';
import 'package:account_manager_client/constant/app_constants.dart';
import 'package:account_manager_client/store/app_global_store.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthService extends BaseService {
  final DeviceService deviceService;
  final Storage storage;

  AuthService(this.deviceService, this.storage);

  Future<bool> attemptAuthentication(String password) async {
    final wrappedResponse = await wrappedPostRequest(
        url: AppConstants.Api.Auth.LOGIN,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "masterPassword": password,
          "secretKey":
              await storage.read(AppConstants.Tags.DEVICE_SECRET_KEY_TAG),
          "deviceMetadata": await deviceService.getDeviceMetadata(),
        }));

    if (wrappedResponse.hasErrorOccurred) return false;
    final response = wrappedResponse.response;

    String token = response['jwtToken'];
    final jwt = JWT.decode(token);
    AppGlobalStore().setToken(token, jwt.payload['role']);

    return true;
  }
}

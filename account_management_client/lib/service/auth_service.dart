import 'dart:convert';

import 'package:account_management_client/constant/app_constants.dart';
import 'package:account_management_client/model/entity/user_device.dart';
import 'package:account_management_client/service/base_service.dart';
import 'package:account_management_client/service/device_service.dart';
import 'package:account_management_client/storage/storage.dart';
import 'package:account_management_client/store/app_global_store.dart';

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
    UserDevice userDevice = UserDevice.fromJson(response['userDeviceDTO']);
    AppGlobalStore().setToken(token, userDevice);

    return true;
  }
}

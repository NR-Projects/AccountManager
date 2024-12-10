import 'dart:convert';

import 'package:account_management_client/model/entity/user_device.dart';
import 'package:account_management_client/service/base_service.dart';
import 'package:account_management_client/service/device_service.dart';
import 'package:account_management_client/constant/app_constants.dart';
import 'package:account_management_client/storage/storage.dart';

class UserDeviceService extends BaseService {
  final DeviceService deviceService;
  final Storage storage;

  UserDeviceService(this.deviceService, this.storage);

  Future<bool> checkIfSecretExistLocally() async {
    String? secretKey =
        await storage.read(AppConstants.Tags.DEVICE_SECRET_KEY_TAG);
    if (secretKey != null) return true;
    return false;
  }

  Future<void> deleteSecretKey() async {
    await storage.delete(AppConstants.Tags.DEVICE_SECRET_KEY_TAG);
  }

  Future<bool> registerUserDevice(String registerSecret) async {
    final wrappedResponse = await wrappedPostRequest(
      url: AppConstants.Api.UserDevice.REGISTER_USER_DEVICE,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'registerSecret': registerSecret,
        'deviceMetadata': await deviceService.getDeviceMetadata()
      }),
    );

    if (wrappedResponse.hasErrorOccurred) return false;
    final response = wrappedResponse.response;

    String secretKey = response['secretKey'];
    storage.write(AppConstants.Tags.DEVICE_SECRET_KEY_TAG, secretKey);

    return true;
  }

  Future<List<UserDevice>> getAllUserDevices() async {
    final wrappedResponse = await wrappedGetRequest(
      url: AppConstants.Api.UserDevice.ALL_USERS,
    );

    if (wrappedResponse.hasErrorOccurred) return List.empty();

    return (wrappedResponse.response as List<dynamic>)
        .map((item) => UserDevice.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<bool> updateUserDevice(UserDevice userDevice) async {
    final wrappedResponse = await wrappedPutRequest(
      url: AppConstants.Api.UserDevice.UPDATE_USER,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userDevice),
    );

    return !wrappedResponse.hasErrorOccurred;
  }

  Future<bool> deleteUserDevice(String userId) async {
    final wrappedResponse = await wrappedDeleteRequest(
      url: "${AppConstants.Api.UserDevice.DELETE_USER}/$userId",
    );

    return !wrappedResponse.hasErrorOccurred;
  }
}

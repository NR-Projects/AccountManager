import 'dart:convert';

import 'package:account_manager_client/model/domain/user_model.dart';
import 'package:account_manager_client/service/base_service.dart';
import 'package:account_manager_client/service/device_service.dart';
import 'package:account_manager_client/constant/app_constants.dart';
import 'package:account_manager_client/storage/storage.dart';

class UserService extends BaseService {
  final DeviceService deviceService;
  final Storage storage;

  UserService(this.deviceService, this.storage);

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
      url: AppConstants.Api.User.REGISTER_USER_DEVICE,
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

  Future<List<User>> getAllUsers() async {
    final wrappedResponse = await wrappedGetRequest(
      url: AppConstants.Api.User.ALL_USERS,
    );

    if (wrappedResponse.hasErrorOccurred) return List.empty();

    return (wrappedResponse.response as List<dynamic>)
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<bool> updateUser(User user) async {
    final wrappedResponse = await wrappedPutRequest(
      url: AppConstants.Api.User.UPDATE_USER,
      headers: { "Content-Type": "application/json" },
      body: jsonEncode(user),
    );

    return !wrappedResponse.hasErrorOccurred;
  }

  Future<bool> deleteUser(String userId) async {
    final wrappedResponse = await wrappedDeleteRequest(
      url: "AppConstants.Api.User.DELETE_USER/$userId",
    );

    return !wrappedResponse.hasErrorOccurred;
  }
}

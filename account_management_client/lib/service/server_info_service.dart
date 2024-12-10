
import 'package:account_management_client/constant/app_constants.dart';
import 'package:account_management_client/model/entity/server_info.dart';
import 'package:account_management_client/service/base_service.dart';

class ServerInfoService extends BaseService {
  Future<bool> enableGuestRequestState() async {
    final wrappedResponse = await wrappedPostRequest(
      url: AppConstants.Api.ServerConfig.ENABLE_GUEST_REQUESTS,
      headers: {}
    );

    return !wrappedResponse.hasErrorOccurred;
  }

  Future<bool> disableGuestRequestState() async {
    final wrappedResponse = await wrappedPostRequest(
      url: AppConstants.Api.ServerConfig.DISABLE_GUEST_REQUESTS
    );

    return !wrappedResponse.hasErrorOccurred;
  }

  Future<ServerInfo> getServerConfig() async {
    final wrappedResponse = await wrappedGetRequest(
      url: AppConstants.Api.ServerConfig.GET_SERVER_CONFIG,
    );
    
    return ServerInfo.fromJson(wrappedResponse.response);
  }

  Future<bool> changeMasterPassword(String newMasterPassword) async {
    final wrappedResponse = await wrappedPutRequest(
      url: AppConstants.Api.ServerConfig.CHANGE_MASTER_PASSWORD,
      headers: { "Content-Type": "application/json" },
      body: newMasterPassword
    );

    return !wrappedResponse.hasErrorOccurred;
  }

  Future<bool> addNewRegisterSecret() async {
    final wrappedResponse = await wrappedPostRequest(
      url: AppConstants.Api.ServerConfig.ADD_REGISTER_SECRET
    );

    return !wrappedResponse.hasErrorOccurred;
  }
}
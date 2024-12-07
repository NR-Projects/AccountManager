import 'package:account_manager_client/constant/app_constants.dart';
import 'package:account_manager_client/model/domain/server_config_model.dart';
import 'package:account_manager_client/service/base_service.dart';

class ServerConfigService extends BaseService {

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

  Future<ServerConfig> getServerConfig() async {
    final wrappedResponse = await wrappedGetRequest(
      url: AppConstants.Api.ServerConfig.GET_SERVER_CONFIG,
    );
    
    return ServerConfig.fromJson(wrappedResponse.response);
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
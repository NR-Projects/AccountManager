import 'package:account_manager_client/service/auth_service.dart';
import 'package:account_manager_client/service/device_service.dart';
import 'package:account_manager_client/service/server_config_service.dart';
import 'package:account_manager_client/service/user_service.dart';
import 'package:account_manager_client/storage/secure_storage.dart';
import 'package:account_manager_client/storage/storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

void setupDependencies() {
  
  getIt.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
  
  getIt.registerLazySingleton<Storage>(() => SecureStorage());
  
  getIt.registerLazySingleton<DeviceService>(() => DeviceService(getIt<DeviceInfoPlugin>()));
  getIt.registerLazySingleton<ServerConfigService>(() => ServerConfigService());
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<DeviceService>(), getIt<Storage>()));
  getIt.registerLazySingleton<UserService>(() => UserService(getIt<DeviceService>(), getIt<Storage>()));

}

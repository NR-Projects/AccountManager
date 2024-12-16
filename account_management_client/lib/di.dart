import 'package:account_management_client/service/account_service.dart';
import 'package:account_management_client/service/auth_service.dart';
import 'package:account_management_client/service/device_service.dart';
import 'package:account_management_client/service/server_info_service.dart';
import 'package:account_management_client/service/site_service.dart';
import 'package:account_management_client/service/user_device_service.dart';
import 'package:account_management_client/storage/secure_storage.dart';
import 'package:account_management_client/storage/storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  
  getIt.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
  
  getIt.registerLazySingleton<Storage>(() => SecureStorage());
  
  getIt.registerLazySingleton<DeviceService>(() => DeviceService(getIt<DeviceInfoPlugin>()));
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<DeviceService>(), getIt<Storage>()));
  getIt.registerLazySingleton<UserDeviceService>(() => UserDeviceService(getIt<DeviceService>(), getIt<Storage>()));
  getIt.registerLazySingleton<ServerInfoService>(() => ServerInfoService());
  getIt.registerLazySingleton<SiteService>(() => SiteService());
  getIt.registerLazySingleton<AccountService>(() => AccountService());
}
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  final DeviceInfoPlugin deviceInfoPlugin;

  DeviceService(this.deviceInfoPlugin);

  Future<Map<String, String>> getDeviceMetadata() async {
    Map<String, String> deviceMetadata = {};

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      deviceMetadata['deviceOS'] = 'Android ${androidInfo.version.release}';
      deviceMetadata['deviceModel'] = androidInfo.model;
      deviceMetadata['manufacturer'] = androidInfo.manufacturer;
      deviceMetadata['hardware'] = androidInfo.hardware;
      deviceMetadata['versionSDK'] = androidInfo.version.sdkInt.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      deviceMetadata['deviceOS'] = 'iOS ${iosInfo.systemVersion}';
      deviceMetadata['deviceModel'] = iosInfo.utsname.machine;
      deviceMetadata['systemName'] = iosInfo.systemName;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
      deviceMetadata['deviceOS'] = 'Windows ${windowsInfo.displayVersion}';
      deviceMetadata['deviceModel'] = windowsInfo.productName;
      deviceMetadata['buildNumber'] = windowsInfo.buildLab;
      deviceMetadata['releaseId'] = windowsInfo.releaseId;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await deviceInfoPlugin.macOsInfo;
      deviceMetadata['deviceOS'] = 'macOS ${macInfo.osRelease}';
      deviceMetadata['deviceModel'] = macInfo.model;
      deviceMetadata['systemName'] = macInfo.computerName;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
      deviceMetadata['deviceOS'] = linuxInfo.version ?? 'Unknown';
      deviceMetadata['deviceModel'] = linuxInfo.prettyName;
      deviceMetadata['kernelVersion'] = linuxInfo.version ?? 'Unknown';
    } else {
      deviceMetadata['deviceOS'] = 'Unknown';
      deviceMetadata['deviceModel'] = 'Unknown';
    }

    return deviceMetadata;
  }
}

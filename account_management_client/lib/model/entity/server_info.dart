class ServerInfo {
  String id;
  bool userDeviceAccessState;
  List<String> deviceRegisterSecrets;
  DateTime lastModifiedDate;

  ServerInfo({
    required this.id,
    required this.userDeviceAccessState,
    required this.deviceRegisterSecrets,
    required this.lastModifiedDate,
  });

  factory ServerInfo.emptyConfig() {
    return ServerInfo(
      id: '',
      userDeviceAccessState: false,
      deviceRegisterSecrets: [],
      lastModifiedDate: DateTime.now(),
    );
  }

  factory ServerInfo.fromJson(Map<String, dynamic> json) {
    return ServerInfo(
        id: json['id'],
        userDeviceAccessState: json['userDeviceAccessState'],
        deviceRegisterSecrets:  json['deviceRegisterSecrets'] != null && json['deviceRegisterSecrets'] is List ? List<String>.from(json['deviceRegisterSecrets'].whereType<String>()) : [],
        lastModifiedDate: DateTime.parse(json['lastModifiedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userDeviceAccessState': userDeviceAccessState,
      'deviceRegisterSecrets': deviceRegisterSecrets,
      'lastModifiedDate': lastModifiedDate,
    };
  }
}

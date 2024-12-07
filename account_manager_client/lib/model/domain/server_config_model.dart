class ServerConfig {
  String id;
  String masterPassword;
  bool guestRequestState;
  DateTime lastUpdated;
  List<String> deviceRegisterSecrets;

  ServerConfig({
    required this.id,
    required this.masterPassword,
    required this.guestRequestState,
    required this.lastUpdated,
    required this.deviceRegisterSecrets,
  });

  factory ServerConfig.emptyConfig() {
    return ServerConfig(
      id: '',
      masterPassword: '',
      guestRequestState: false,
      lastUpdated: DateTime.now(),
      deviceRegisterSecrets: []
    );
  }

  factory ServerConfig.fromJson(Map<String, dynamic> json) {
    return ServerConfig(
        id: json['id'],
        masterPassword: json['masterPassword'],
        guestRequestState: json['guestRequestState'],
        lastUpdated: DateTime.parse(json['lastUpdated']),
        deviceRegisterSecrets:  json['deviceRegisterSecrets'] != null && json['deviceRegisterSecrets'] is List ? List<String>.from(json['deviceRegisterSecrets'].whereType<String>()) : []
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'masterPassword': masterPassword,
      'guestRequestState': guestRequestState,
      'lastUpdated': lastUpdated,
      'deviceRegisterSecrets': deviceRegisterSecrets
    };
  }
}

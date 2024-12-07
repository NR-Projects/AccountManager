// ignore_for_file: constant_identifier_names

class User {
  String id;
  Device device;
  String role;
  User({required this.id, required this.device, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        device: Device.fromJson(json['device']),
        role: json['role']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'device': device.toJson(), 'role': role};
  }
}

class Device {
  String label;
  String secretKey;
  Map<String, String> metadata;
  int allowedTokenRequestCount;

  Device(
      {required this.label,
      required this.secretKey,
      required this.metadata,
      required this.allowedTokenRequestCount});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      label: json['label'],
      secretKey: json['secretKey'],
      metadata: Map<String, String>.from(json['metadata']),
      allowedTokenRequestCount: json['allowedTokenRequestCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'secretKey': secretKey,
      'metadata': metadata,
      'allowedTokenRequestCount': allowedTokenRequestCount,
    };
  }
}

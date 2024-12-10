class UserDevice {
  String id;
  String role;
  String label;
  Map<String, String> metadata;
  int allowedTokenRequestCount;

  UserDevice(
      {required this.id,
      required this.role,
      required this.label,
      required this.metadata,
      required this.allowedTokenRequestCount});

  factory UserDevice.fromJson(Map<String, dynamic> json) {
    return UserDevice(
        id: json['id'],
        role: json['role'],
        label: json['label'],
        metadata: Map<String, String>.from(json['metadata']),
        allowedTokenRequestCount: json['allowedTokenRequestCount']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'label': label,
      'metadata': metadata,
      'allowedTokenRequestCount': allowedTokenRequestCount,
    };
  }
}

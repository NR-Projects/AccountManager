class UserDevice {
  String id;
  String label;
  Map<String, String> metadata;
  int allowedTokenRequestCount;

  UserDevice(
      {required this.id,
      required this.label,
      required this.metadata,
      required this.allowedTokenRequestCount});

  factory UserDevice.fromJson(Map<String, dynamic> json) {
    return UserDevice(
        id: json['id'],
        label: json['label'],
        metadata: Map<String, String>.from(json['metadata']),
        allowedTokenRequestCount: json['allowedTokenRequestCount']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'metadata': metadata,
      'allowedTokenRequestCount': allowedTokenRequestCount,
    };
  }
}

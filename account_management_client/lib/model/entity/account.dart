class Account {
  String id;
  String accountType;
  String siteName;
  String label;
  String notes;

  String? username;
  String? linkedAccountId;

  String? password;

  Account({
    required this.id,
    required this.accountType,
    required this.siteName,
    required this.label,
    required this.notes,

    this.username,
    this.linkedAccountId,
  });


  Account.withPassword({
    required this.id,
    required this.accountType,
    required this.siteName,
    required this.label,
    required this.notes,

    this.username,
    this.linkedAccountId,
    this.password
  });

  factory Account.initEmpty() {
    return Account(id: '', accountType: 'USERNAME_PASSWORD', siteName: '', label: '', notes: '');
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        id: json['id'],
        accountType: json['accountType'],
        siteName: json['siteName'],
        label: json['label'],
        notes:  json['notes'],

        username: json['username'],
        linkedAccountId: json['linkedAccountId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountType': accountType,
      'siteName': siteName,
      'label': label,
      'notes': notes,
      
      'username': username,
      'password': password,
      'linkedAccountId': linkedAccountId,
    };
  }
}
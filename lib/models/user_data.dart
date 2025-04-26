class UserData {
  final String id;
  final String token;
  final String displayName;
  final String email;
  final String type;
  final String photoUrl;
  final bool isSubscribed;
  final DateTime? expirationDate;

  UserData({
    required this.id,
    required this.token,
    required this.displayName,
    required this.email,
    required this.type,
    required this.photoUrl,
    required this.isSubscribed,
    this.expirationDate,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      token: json['token'],
      displayName: json['displayName'],
      email: json['email'],
      type: json['type'],
      photoUrl: json['photoUrl'],
      isSubscribed: json['isSubscribed'],
      expirationDate: DateTime.parse(json['expirationDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}

class UserData {
  final String id;
  final String? nusp;
  final String? displayName;
  final String? email;
  final String? type;
  final String? photoUrl;
  final bool? isSubscribed;
  final DateTime? expirationDate;
  final bool? nuspModified;

  UserData({
    required this.id,
    this.nusp,
    this.displayName,
    this.email,
    this.type,
    this.photoUrl,
    this.isSubscribed,
    this.expirationDate,
    this.nuspModified,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      nusp: json['nusp'],
      displayName: json['displayName'],
      email: json['email'],
      type: json['type'],
      photoUrl: json['photoUrl'],
      isSubscribed: json['isSubscribed'],
      expirationDate: DateTime.parse(json['expirationDate']),
      nuspModified: json['nuspModified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nusp': nusp,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}

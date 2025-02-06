class UserData {
  final String id;
  final String? nusp;
  final String? displayName;
  final String? photoUrl;
  final bool? isSubscribed;
  final DateTime? expirationDate;

  UserData({
    required this.id,
    this.nusp,
    this.displayName,
    this.photoUrl,
    this.isSubscribed,
    this.expirationDate,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      nusp: json['nusp'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      isSubscribed: json['isSubscribed'],
      expirationDate: DateTime.parse(json['expirationDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nusp': nusp,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  static UserData empty() {
    return UserData(
      id: '',
    );
  }
}

class User {
  final String id;
  final String name;
  final String category;
  final String email;
  final String nusp;
  final DateTime birthDate;
  final DateTime expirationDate;

  User({
    required this.id,
    required this.name,
    required this.category,
    required this.email,
    required this.nusp,
    required this.birthDate,
    required this.expirationDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      email: json['email'],
      nusp: json['nusp'],
      birthDate: DateTime.parse(json['birthDate']),
      expirationDate: DateTime.parse(json['expirationDate']),
    );
  }
}

class BenefitData {
  final String title;
  final String description;
  final String photoUrl;

  BenefitData({
    required this.title,
    required this.description,
    required this.photoUrl,
  });

  factory BenefitData.fromJson(Map<String, dynamic> json) {
    return BenefitData(
      title: json['title'],
      description: json['description'],
      photoUrl: json['photoUrl'],
    );
  }
}

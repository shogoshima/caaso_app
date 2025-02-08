class PaymentData {
  final String id;
  final String? qrCode;
  final double? amount;
  final bool? isPaid;
  final DateTime? dateApproved;

  PaymentData({
    required this.id,
    this.qrCode,
    this.amount,
    this.isPaid,
    this.dateApproved,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      id: json['id'],
      qrCode: json['qrCode'],
      amount: json['amount'] is int
          ? json['amount'].toDouble() // Convert int to double
          : json['amount'], // Already a double
      isPaid: json['isPaid'],
      dateApproved: DateTime.parse(json['dateApproved']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qrCode': qrCode,
      'amount': amount,
      'isPaid': isPaid,
      'dateApproved': dateApproved?.toIso8601String(),
    };
  }
}

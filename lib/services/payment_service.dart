import 'package:caaso_app/common/secure_storage.dart';
import 'package:caaso_app/models/models.dart';
import 'package:caaso_app/services/services.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();

  PaymentService._internal();

  factory PaymentService() {
    return _instance;
  }

  Future<PaymentData> createPayment(String userType, String planType) async {
    SecureStorage storage = SecureStorage();
    String? token = await storage.getAccessToken();

    final qrData = {
      'userType': userType,
      'planType': planType,
    };

    final data = await ApiService().post('/auth/payment/create', qrData, token);

    return PaymentData.fromJson(data['payment']);
  }

  Future<PaymentData> getPayment() async {
    SecureStorage storage = SecureStorage();
    String? token = await storage.getAccessToken();

    final data = await ApiService().get('/auth/payment', token);

    return PaymentData.fromJson(data['payment']);
  }
}

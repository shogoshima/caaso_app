import 'package:caaso_app/common/secure_storage.dart';
import 'package:caaso_app/models/models.dart';
import 'package:caaso_app/services/services.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();

  PaymentService._internal();

  factory PaymentService() {
    return _instance;
  }

  Future<PaymentData> createPayment(
      UserType userType, PlanType planType) async {
    SecureStorage storage = SecureStorage();
    String? token = await storage.getAccessToken();

    final qrData = {
      'userType': userType.index,
      'planType': planType.index,
    };

    final data = await ApiService().post('/payment/create', qrData, token);

    return PaymentData.fromJson(data['payment']);
  }

  Future<PaymentData> getPayment() async {
    SecureStorage storage = SecureStorage();
    String? token = await storage.getAccessToken();

    final data = await ApiService().get('/payment', token);

    return PaymentData.fromJson(data['payment']);
  }
}

import 'package:caaso_app/common/secure_storage.dart';
import 'package:caaso_app/models/models.dart';
import 'package:caaso_app/services/services.dart';

class PaymentService {
  final ApiService api;

  PaymentService(this.api);

  Future<PaymentData> createPayment(
      UserType userType, PlanType planType) async {
    SecureStorage storage = SecureStorage();
    String? token = await storage.getAccessToken();

    final qrData = {
      'userType': userType.index,
      'planType': planType.index,
    };

    final data = await api.post('/payment/create', qrData, token);

    return PaymentData.fromJson(data['payment']);
  }

  Future<PaymentData> getPayment() async {
    SecureStorage storage = SecureStorage();
    String? token = await storage.getAccessToken();

    final data = await api.get('/payment', token);

    return PaymentData.fromJson(data['payment']);
  }
}

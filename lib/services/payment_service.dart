import 'package:caaso_app/models/models.dart';
import 'package:caaso_app/services/services.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();

  PaymentService._internal();

  factory PaymentService() {
    return _instance;
  }

  Future<PaymentData> createPayment(String userType, String planType) async {
    final qrData = {
      'userType': userType,
      'planType': planType,
    };

    final data = await ApiService().post('/auth/payment/create', qrData);

    return PaymentData.fromJson(data['payment']);
  }

  Future<PaymentData> getPayment() async {
    final data = await ApiService().get('/auth/payment');
    return PaymentData.fromJson(data['payment']);
  }
}

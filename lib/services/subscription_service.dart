import 'api_service.dart';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();

  SubscriptionService._internal();

  factory SubscriptionService() {
    return _instance;
  }

  Future<dynamic> getSubscriptionStatus(String nusp) async {
    final data = await ApiService().get('/subscription/$nusp');
    return data;
  }
}

import 'api_service.dart';

class SubscriptionService {
  final ApiService api;

  SubscriptionService(this.api);

  Future<dynamic> getSubscriptionStatus(String nusp) async {
    final data = await api.get('/subscription/$nusp');
    return data;
  }
}

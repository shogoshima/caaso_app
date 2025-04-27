import 'package:caaso_app/models/models.dart';
import 'package:caaso_app/services/services.dart';

class PlanService {
  static final PlanService _instance = PlanService._internal();

  PlanService._internal();

  factory PlanService() {
    return _instance;
  }

  Future<Map<String, Map<String, double>>> fetchPlans() async {
    final data = await ApiService().get('/plans');

    return buildPriceMap(data['plans']);
  }
}
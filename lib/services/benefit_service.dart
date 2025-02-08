import 'package:caaso_app/models/models.dart';
import 'package:caaso_app/services/services.dart';

class BenefitService {
  final ApiService api;

  BenefitService(this.api);

  Future<List<BenefitData>> fetchBenefits() async {
    final data = await api.get('/benefits');

    return (data['benefits'] as List)
        .map((json) => BenefitData.fromJson(json))
        .toList();
  }
}

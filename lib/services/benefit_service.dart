import 'package:caaso_app/models/models.dart';
import 'package:caaso_app/services/services.dart';

class BenefitService {
  static final BenefitService _instance = BenefitService._internal();

  BenefitService._internal();

  factory BenefitService() {
    return _instance;
  }

  Future<List<BenefitData>> fetchBenefits() async {
    final data = await ApiService().get('/benefits');

    final benefits = (data['benefits'] as List)
        .map((json) => BenefitData.fromJson(json))
        .toList();

    benefits.sort((a, b) => a.title.compareTo(b.title));

    return benefits;
  }
}

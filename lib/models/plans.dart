/// Constrói o mapa aninhado diretamente de String para String:
Map<String, Map<String, double>> buildPriceMap(List<dynamic> list) {
  final map = <String, Map<String, double>>{};
  for (var p in list) {
    final ut = p['userType'] as String;
    final pt = p['planType'] as String;
    final amount = (p['amount'] as num).toDouble();
    map.putIfAbsent(ut, () => {})[pt] = amount;
  }
  return map;
}

/// Retorna uma função que, dado um planType (String), traz o preço:
double? Function(String planType) getPrices(
  String userType,
  Map<String, Map<String, double>> priceMap,
) {
  return (String planType) {
    return priceMap[userType]?[planType];
  };
}

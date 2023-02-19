class Invoice {
  late double income;
  late double cost;
  late double freeCost;
  Invoice({
    required this.income,
    required this.cost,
    required this.freeCost,
  });
  Invoice.fromJson(Map<String, dynamic>? json) {
    income = json?['incom'];
    cost = json?['cost'];
    freeCost = json?['cost_free'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['incom'] = income;
    data['cost'] = cost;
    data['cost_free'] = freeCost;
    return data;
  }
}

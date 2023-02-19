class Day {
  late String id;
  late double income;
  late double cost;
  late double prifit;
  Day({
    required this.id,
    required this.income,
    required this.cost,
    required this.prifit,
  });

  Day.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    income = (json?['income'] ?? 0).toDouble();
    cost = (json?['cost'] ?? 0).toDouble();
    prifit = (json?['profit'] ?? 0).toDouble();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['income'] = income;
    data['cost'] = cost;
    data['profit'] = prifit;

    return data;
  }
}

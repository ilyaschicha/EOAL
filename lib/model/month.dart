import 'package:best_inox/model/day.dart';

class Month {
  late String id;
  late String version;
  late List<Day> days;
  late double totalIncome;
  late double totalCost;
  late double totalProfit;
  Month({
    required this.id,
    required this.version,
    required this.days,
    required this.totalIncome,
    required this.totalCost,
    required this.totalProfit,
  });

  Month.fromJson(Map<String, dynamic>? json, String d) {
    id = d;
    version = json?['version'];
    days = _listDaysFromJson(json?['days']);
    totalIncome = (json?['total_income']).toDouble();
    totalCost = (json?['total_cost']).toDouble();
    totalProfit = (json?['total_profit']).toDouble();
  }

  List<Day> _listDaysFromJson(Map<String, dynamic>? json) {
    Map<String, dynamic> day;
    List<Day> days = [];
    json?.forEach((key, value) {
      day = value as Map<String, dynamic>;
      day["id"] = key;
      days.add(Day.fromJson(day));
      day = {};
    });
    return days;
  }

  Map<String, dynamic> _listDaysToJson(List<Day> d) {
    Map<String, dynamic> json = {};
    for (var element in d) {
      json.addAll({element.id: element.toJson()});
    }
    return json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['version'] = version;
    data['days'] = _listDaysToJson(days);
    data['total_income'] = totalIncome;
    data['total_cost'] = totalCost;
    data['total_profit'] = totalProfit;
    return data;
  }
}

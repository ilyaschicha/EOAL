import 'package:best_inox/model/day.dart';
import 'package:best_inox/model/invoice.dart';
import 'package:best_inox/model/month.dart';
// import 'package:best_inox/model/year.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class InvoiceProvider extends ChangeNotifier {
  static InvoiceProvider? _instance;
  static InvoiceProvider? get instance => _instance;
  static Future init(BuildContext context) async {
    _instance = Provider.of<InvoiceProvider>(context, listen: false);
  }

  // List<Month>? _Months;
  // List<Year>? _Years;

  Future<List<Month>?> getYear(int year) async {
    return await FirebaseFirestore.instance
        .collection("invoice")
        .doc(year.toString())
        .collection("months")
        .get()
        .then((value) {
      return value.docs.map((e) {
        return Month.fromJson(e.data(), e.id);
      }).toList();
    });
  }

  void addInvoice(Invoice i) async {
    DateTime s = DateTime.now();
    Month m = await FirebaseFirestore.instance
        .collection("invoice")
        .doc(s.year.toString())
        .collection("months")
        .doc(s.month.toString())
        .get()
        .then(
          (value) => Month.fromJson(value.data(), value.id),
        );
    // m.days.add(Day(id: s.day.toString(), cost: 0, income: 0, prifit: 0));
    // m.totalCost = 0;
    // m.totalIncome = 0;
    // m.totalProfit = 0;
    m.days.add(Day(
        id: s.day.toString(),
        cost: i.cost,
        income: i.income,
        prifit: i.freeCost));
    m.totalCost += i.cost;
    m.totalIncome += i.income;
    m.totalProfit += i.freeCost;
    await FirebaseFirestore.instance
        .collection("invoice")
        .doc(s.year.toString())
        .collection('months')
        .doc(s.month.toString())
        .set(m.toJson());

    notifyListeners();
  }
}

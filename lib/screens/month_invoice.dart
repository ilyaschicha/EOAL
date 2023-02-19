import 'package:best_inox/model/day.dart';
import 'package:best_inox/model/month.dart';
import 'package:flutter/material.dart';

class MonthInvoice extends StatelessWidget {
  final Month? month;
  const MonthInvoice({
    super.key,
    this.month,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Month invoice")),
      body: Column(
        children: [
          Container(),
          const SizedBox(height: 30),
          DaysTable(days: month?.days),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        color: const Color(0xFF93221E),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "total month income : ${month?.totalIncome.toString()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "total month cost : ${month?.totalCost.toString()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "total month profite : ${month?.totalProfit.toString()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DaysTable extends StatelessWidget {
  final List<Day>? days;
  const DaysTable({
    super.key,
    this.days,
  });

  @override
  Widget build(BuildContext context) {
    days?.sort(
      (a, b) => int.parse(a.id).compareTo(int.parse(b.id)),
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: 20,
            child: Row(
              children: const [
                Expanded(
                  child: Text(
                    "Day",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    "income",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    "cost",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    "profit",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 500,
            child: ListView(
              children: List.generate(
                days?.length ?? 0,
                (index) => SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "${days?[index].id}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )),
                      Expanded(
                          child: Text("${days?[index].income.toString()}")),
                      Expanded(child: Text("${days?[index].cost.toString()}")),
                      Expanded(
                          child: Text("${days?[index].prifit.toString()}")),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

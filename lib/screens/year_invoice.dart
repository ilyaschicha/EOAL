import 'package:best_inox/model/month.dart';
import 'package:best_inox/screens/month_invoice.dart';
import 'package:best_inox/provider/invoice.dart';
import 'package:flutter/material.dart';

class YearInvoice extends StatefulWidget {
  final List<Month>? months;
  const YearInvoice({super.key, this.months});

  @override
  State<YearInvoice> createState() => _YearInvoiceState();
}

class _YearInvoiceState extends State<YearInvoice> {
  int fixedYear = 2022;
  int thisYear = DateTime.now().year;
  int year = DateTime.now().year;
  double totalIncome = 0;
  double totalCost = 0;
  double totalProfit = 0;
  InvoiceProvider? provider = InvoiceProvider.instance;
  @override
  void initState() {
    year = thisYear;

    super.initState();
  }

  void getYeardata() async {
    List<Month>? monthss = await provider?.getYear(year);
    double a = 0;
    double b = 0;
    double c = 0;

    for (var element in monthss ?? []) {
      a += element.totalCost;
      b += element.totalIncome;
      c += element.totalProfit;
    }
    setState(() {
      totalCost = a;
      totalIncome = b;
      totalProfit = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    InvoiceProvider? provider = InvoiceProvider.instance;
    return Scaffold(
      drawer: Drawer(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              color: const Color(0xFF93221E),
            ),
            ListTile(
              leading: const Icon(Icons.home_max_outlined, size: 35),
              title: const Text("Home"),
              subtitle: const Text("Home Page"),
              isThreeLine: true,
              iconColor: const Color(0xFF93221E),
              onTap: () => Navigator.pushNamed(context, "/year-invoice"),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded, size: 35),
              title: const Text("profile"),
              subtitle: const Text("personal information"),
              isThreeLine: true,
              iconColor: const Color(0xFF93221E),
              onTap: () => Navigator.pushNamed(context, "/profile"),
            ),
            ListTile(
              leading: const Icon(Icons.request_page_sharp, size: 35),
              title: const Text("Invoice"),
              subtitle: const Text("Create Invoice"),
              isThreeLine: true,
              iconColor: const Color(0xFF93221E),
              onTap: () => Navigator.pushNamed(context, "/create-invoice"),
            ),
          ],
        ),
      ),
      appBar: AppBar(title: const Text("Year Invoice")),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: const Color(0xFF93221E),
        height: 80,
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
                    "total year income : ${totalIncome.toString()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "total year cost : ${totalCost.toString()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "total year profite : ${totalProfit.toString()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: fixedYear == year
                    ? null
                    : () {
                        setState(() => year = year - 1);
                      },
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
              Text(year.toString()),
              IconButton(
                onPressed: thisYear == year
                    ? null
                    : () {
                        setState(() => year = year + 1);
                      },
                icon: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Month>?>(
              future: provider?.getYear(year),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  getYeardata();
                  snapshot.data?.sort(
                    (a, b) => int.parse(a.id).compareTo(int.parse(b.id)),
                  );
                  return ListView(
                    children: List.generate(
                      snapshot.data?.length ?? 0,
                      (index) => Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0x0A000000),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MonthInvoice(
                                  month: snapshot.data?[index],
                                ),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getMonth(int.parse(snapshot.data![index].id)),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "Income: ${snapshot.data?[index].totalIncome.toString()}"),
                                  Text(
                                      "Cost: ${snapshot.data?[index].totalCost.toString()}"),
                                  Text(
                                      "Profite: ${snapshot.data?[index].totalProfit.toString()}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

String getMonth(int m) {
  switch (m) {
    case 1:
      return "January";
    case 2:
      return "Fabruary";
    case 3:
      return "March";
    case 4:
      return "Aprile";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
    default:
      return "Null";
  }
}

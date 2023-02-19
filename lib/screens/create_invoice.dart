import 'package:best_inox/model/invoice.dart';
import 'package:best_inox/provider/invoice.dart';
import 'package:best_inox/screens/year_invoice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// ignore: must_be_immutable
class CreateInvoice extends StatelessWidget {
  CreateInvoice({super.key});
  TextEditingController income = TextEditingController();
  TextEditingController cost = TextEditingController();
  FocusNode costNode = FocusNode();
  FocusNode incomeNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Future<String> getLastInvoiceDate() async {
    Box b = await Hive.openBox<String>('date');
    return b.get("last-invoice", defaultValue: "23-12-2022");
    // return "";
  }

  void changeDate(String date) async {
    Box b = await Hive.openBox<String>('date');
    b.put("last-invoice", date);
  }

  @override
  Widget build(BuildContext context) {
    InvoiceProvider? provider = InvoiceProvider.instance;
    final auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Invoice"),
        leading: auth.currentUser?.uid != "JJbq9Ak30wUloakTheBSvpnSmzj1"
            ? IconButton(
                onPressed: () => Navigator.pushNamed(context, "/profile"),
                icon: const Icon(Icons.arrow_back_ios_rounded),
              )
            : null,
      ),
      drawer: auth.currentUser?.uid != "JJbq9Ak30wUloakTheBSvpnSmzj1"
          ? null
          : Drawer(
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
                    onTap: () =>
                        Navigator.pushNamed(context, "/create-invoice"),
                  ),
                ],
              ),
            ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<Object>(
            future: getLastInvoiceDate(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data !=
                    "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}") {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "invoice day : ${DateTime.now().day} ${getMonth(DateTime.now().month)} ${DateTime.now().year}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                String r = r'^([0-9]{1,25})+$';
                                if (value == null) {
                                  return "income can't be empty";
                                } else {
                                  RegExp regExp = RegExp(r);
                                  if (regExp.hasMatch(value)) {
                                    return null;
                                  } else {
                                    return "please enter number";
                                  }
                                }
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "income",
                                prefixIcon: Icon(Icons.add_card_outlined),
                                suffix: Text(
                                  "DZD",
                                  style: TextStyle(
                                    color: Color(0xFF93221E),
                                  ),
                                ),
                              ),
                              controller: income,
                              focusNode: incomeNode,
                            ),
                            TextFormField(
                              validator: (value) {
                                String r = r'^([0-9]{1,25})+$';
                                if (value == null) {
                                  return "cost can't be empty";
                                } else {
                                  RegExp regExp = RegExp(r);
                                  if (regExp.hasMatch(value)) {
                                    return null;
                                  } else {
                                    return "please enter number";
                                  }
                                }
                              },
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: "Cost",
                                prefixIcon: Icon(Icons.credit_card),
                                suffix: Text(
                                  "DZD",
                                  style: TextStyle(
                                    color: Color(0xFF93221E),
                                  ),
                                ),
                              ),
                              controller: cost,
                              focusNode: costNode,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 60,
                        child: OutlinedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              double a = double.parse(cost.text);
                              double b = double.parse(income.text);
                              double c = b - a;
                              provider?.addInvoice(
                                Invoice(cost: a, income: b, freeCost: c),
                              );
                              changeDate(
                                  "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
                              Navigator.pushReplacementNamed(
                                  context, "/create-invoice");
                            }
                          },
                          child: const Text("Add Invoice"),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                } else {
                  return const Center(
                      child: Text(
                    "you allready add today invoice",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ));
                }
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}

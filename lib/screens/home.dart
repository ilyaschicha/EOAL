import 'package:best_inox/provider/invoice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    InvoiceProvider provider =
        Provider.of<InvoiceProvider>(context, listen: false);
    return const Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => provider.oneTime(),
      //   child: const Icon(Icons.check),
      // ),
      body: Center(child: Text("this is the home page")),
    );
  }
}

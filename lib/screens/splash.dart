import 'dart:async';
import 'dart:io';

import 'package:best_inox/provider/invoice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _init = true;

  @override
  void initState() {
    initTime();
    super.initState();
  }

  void initTime() async {
    if (await checkInternet()) {
      final auth = FirebaseAuth.instance;
      await InvoiceProvider.init(context);
      Timer(const Duration(seconds: 3), () {
        if (auth.currentUser?.uid == null) {
          Navigator.of(context).pushReplacementNamed("/sign-in");
        } else if (auth.currentUser?.uid == "JJbq9Ak30wUloakTheBSvpnSmzj1") {
          Navigator.of(context).pushReplacementNamed('/year-invoice');
        } else if (auth.currentUser?.uid == "ZINk5HlMMIRQP3df4X1szjFIbC43") {
          Navigator.pushNamed(context, '/create-invoice');
        } else {
          Navigator.pushNamed(context, '/unkown');
        }
      });
    } else {
      setState(() {
        _init = false;
      });
      await _dialogBuilder(context);
    }
  }

  Future<dynamic> _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("No Internet Connection"),
        content:
            const Text("Please turn on internet connection to continue..."),
        actions: [
          TextButton(
            child: const Text("Refresh"),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _init = true;
              });
              initTime();
            },
          ),
          TextButton(
            child: const Text("Close"),
            onPressed: () => exit(0),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<bool> checkInternet() async =>
      ((await Connectivity().checkConnectivity()) ==
                  ConnectivityResult.mobile ||
              (await Connectivity().checkConnectivity()) ==
                  ConnectivityResult.wifi ||
              (await Connectivity().checkConnectivity()) ==
                  ConnectivityResult.ethernet)
          ? true
          : false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF93221E),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/logo.svg"),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

import 'package:best_inox/config.dart';
import 'package:best_inox/decorations.dart';
import 'package:best_inox/screens/create_invoice.dart';
import 'package:best_inox/firebase_options.dart';
import 'package:best_inox/screens/home.dart';
import 'package:best_inox/screens/month_invoice.dart';
import 'package:best_inox/provider/invoice.dart';
import 'package:best_inox/screens/sign_up.dart';
import 'package:best_inox/screens/splash.dart';
import 'package:best_inox/screens/year_invoice.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  runApp(const MyApp());

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: GOOGLE_CLIENT_ID),
    // PhoneAuthProvider(),
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // String get initialRoute {
  //   final auth = FirebaseAuth.instance;
  //   if (auth.currentUser == null) {
  //     return '/';
  //   }
  //   if (auth.currentUser?.uid == "JJbq9Ak30wUloakTheBSvpnSmzj1") {
  //     return '/year-invoice';
  //   } else {
  //     return '/create-invoice';
  //   }
  //   // return '/home';
  // }

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    final mfaAction = AuthStateChangeAction<MFARequired>(
      (context, state) async {
        final nav = Navigator.of(context);

        UserCredential? user = await startMFAVerification(
          resolver: state.resolver,
          context: context,
        );
        if (user.user?.uid == "JJbq9Ak30wUloakTheBSvpnSmzj1") {
          nav.pushReplacementNamed('/year-invoice');
        } else {
          nav.pushReplacementNamed('/create-invoice');
        }
      },
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const Splash(),
          '/sign-in': (context) => SignIn(mfaAction: mfaAction),
          // '/sms': (context) {
          //   final arguments = ModalRoute.of(context)?.settings.arguments
          //       as Map<String, dynamic>?;

          //   return SMSCodeInputScreen(
          //     actions: [
          //       AuthStateChangeAction<SignedIn>((context, state) {
          //         Navigator.of(context).pushReplacementNamed('/profile');
          //       })
          //     ],
          //     flowKey: arguments?['flowKey'],
          //     action: arguments?['action'],
          //     headerBuilder: headerIcon(Icons.sms_outlined),
          //     sideBuilder: sideIcon(Icons.sms_outlined),
          //   );
          // },
          '/forgot-password': (context) {
            final arguments = ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>?;

            return ForgotPasswordScreen(
              email: arguments?['email'],
              headerMaxExtent: 200,
              headerBuilder: headerIcon(Icons.lock),
              sideBuilder: sideIcon(Icons.lock),
            );
          },
          // '/phone': (context) {
          //   return PhoneInputScreen(
          //     actions: [
          //       SMSCodeRequestedAction((context, action, flowKey, phone) {
          //         Navigator.of(context).pushReplacementNamed(
          //           '/sms',
          //           arguments: {
          //             'action': action,
          //             'flowKey': flowKey,
          //             'phone': phone,
          //           },
          //         );
          //       }),
          //     ],
          //     headerBuilder: headerIcon(Icons.phone),
          //     sideBuilder: sideIcon(Icons.phone),
          //   );
          // },
          '/profile': (context) {
            return ProfileScreen(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      final auth = FirebaseAuth.instance;
                      if (auth.currentUser?.uid == null) {
                        Navigator.of(context).pushReplacementNamed("/sign-in");
                      } else if (auth.currentUser?.uid ==
                          "JJbq9Ak30wUloakTheBSvpnSmzj1") {
                        Navigator.of(context)
                            .pushReplacementNamed('/year-invoice');
                      } else if (auth.currentUser?.uid ==
                          "ZINk5HlMMIRQP3df4X1szjFIbC43") {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushNamed(context, '/unkown');
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                    )),
              ),
              actions: [
                SignedOutAction((context) {
                  Navigator.pushReplacementNamed(context, '/');
                }),
                mfaAction,
              ],
              showMFATile: true,
            );
          },
          '/home': (context) => const Home(),
          '/sign-up': (context) => const SignUp(),
          '/create-invoice': (context) => CreateInvoice(),
          '/month-invoice': (context) => const MonthInvoice(),
          '/year-invoice': (context) => const YearInvoice(),
          '/unkown': (context) => const Unkown(),
        },
        title: 'Best Inox',
        theme: ThemeData(
          primaryColor: const Color(0xFF93221E),
          primarySwatch: buildMaterialColor(const Color(0xFF93221E)),
        ),
      ),
    );
  }
}

class SignIn extends StatelessWidget {
  const SignIn({
    Key? key,
    required this.mfaAction,
  }) : super(key: key);

  final AuthStateChangeAction<MFARequired> mfaAction;

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        ForgotPasswordAction((context, email) {
          Navigator.pushNamed(
            context,
            '/forgot-password',
            arguments: {'email': email},
          );
        }),
        // VerifyPhoneAction((context, _) {
        //   Navigator.pushNamed(context, '/phone');
        // }),
        AuthStateChangeAction<SignedIn>((context, state) {
          if (state.user?.uid == "JJbq9Ak30wUloakTheBSvpnSmzj1") {
            Navigator.pushReplacementNamed(context, '/year-invoice');
          } else if (state.user?.uid == "ZINk5HlMMIRQP3df4X1szjFIbC43") {
            Navigator.pushNamed(context, '/create-invoice');
          } else {
            Navigator.pushNamed(context, '/unkown');
          }
        }),
        AuthStateChangeAction<UserCreated>((context, state) {
          Navigator.pushReplacementNamed(context, '/profile');
        }),
        AuthStateChangeAction<CredentialLinked>((context, state) {
          if (state.user.uid == "JJbq9Ak30wUloakTheBSvpnSmzj1") {
            Navigator.pushReplacementNamed(context, '/year-invoice');
          } else {
            Navigator.pushNamed(context, '/create-invoice');
          }
        }),
        mfaAction,
      ],
      styles: const {
        EmailFormStyle(
          signInButtonVariant: ButtonVariant.filled,
        ),
      },
      headerBuilder: headerImage('assets/icons/colored_logo.svg'),
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            action == AuthAction.signIn
                ? 'Welcome to Firebase UI! Please sign in to continue.'
                : 'Welcome to Firebase UI! Please create an account to continue',
          ),
        );
      },
      showAuthActionSwitch: false,
      footerBuilder: (context, action) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              action == AuthAction.signIn
                  ? 'By signing in, you agree to our terms and conditions.'
                  : 'By registering, you agree to our terms and conditions.',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}

// import 'dart:io';

// import 'package:best_inox/config.dart';
// import 'package:best_inox/decorations.dart';
// import 'package:best_inox/model/profile.dart';
// import 'package:best_inox/provider/profile.dart';
// import 'package:best_inox/screens/create_invoice.dart';
// import 'package:best_inox/firebase_options.dart';
// import 'package:best_inox/screens/home.dart';
// import 'package:best_inox/screens/month_invoice.dart';
// import 'package:best_inox/provider/invoice.dart';
// import 'package:best_inox/screens/sign_up.dart';
// import 'package:best_inox/screens/splash.dart';
// import 'package:best_inox/screens/year_invoice.dart';
// import 'package:firebase_auth/firebase_auth.dart'
//     hide PhoneAuthProvider, EmailAuthProvider;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());

//   FirebaseUIAuth.configureProviders([
//     EmailAuthProvider(),
//     GoogleProvider(clientId: GOOGLE_CLIENT_ID),
//     PhoneAuthProvider(),
//   ]);
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   MaterialColor buildMaterialColor(Color color) {
//     List strengths = <double>[.05];
//     Map<int, Color> swatch = {};
//     final int r = color.red, g = color.green, b = color.blue;

//     for (int i = 1; i < 10; i++) {
//       strengths.add(0.1 * i);
//     }
//     for (var strength in strengths) {
//       final double ds = 0.5 - strength;
//       swatch[(strength * 1000).round()] = Color.fromRGBO(
//         r + ((ds < 0 ? r : (255 - r)) * ds).round(),
//         g + ((ds < 0 ? g : (255 - g)) * ds).round(),
//         b + ((ds < 0 ? b : (255 - b)) * ds).round(),
//         1,
//       );
//     }
//     return MaterialColor(color.value, swatch);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => InvoiceProvider()),
//         ChangeNotifierProvider(create: (_) => ProfileProvider()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: '/',
//         routes: {
//           '/': (context) => const Splash(),
//           '/sign-in': (context) => SignIn(),
//           '/sms': (context) {
//             final arguments = ModalRoute.of(context)?.settings.arguments
//                 as Map<String, dynamic>?;

//             return SMSCodeInputScreen(
//               actions: [
//                 AuthStateChangeAction<SignedIn>((context, state) {
//                   Navigator.of(context).pushReplacementNamed('/profile');
//                 })
//               ],
//               flowKey: arguments?['flowKey'],
//               action: arguments?['action'],
//               headerBuilder: headerIcon(Icons.sms_outlined),
//               sideBuilder: sideIcon(Icons.sms_outlined),
//             );
//           },
//           '/forgot-password': (context) {
//             final arguments = ModalRoute.of(context)?.settings.arguments
//                 as Map<String, dynamic>?;

//             return ForgotPasswordScreen(
//               email: arguments?['email'],
//               headerMaxExtent: 200,
//               headerBuilder: headerIcon(Icons.lock),
//               sideBuilder: sideIcon(Icons.lock),
//             );
//           },
//           '/phone': (context) {
//             return PhoneInputScreen(
//               actions: [
//                 SMSCodeRequestedAction((context, action, flowKey, phone) {
//                   Navigator.of(context).pushReplacementNamed(
//                     '/sms',
//                     arguments: {
//                       'action': action,
//                       'flowKey': flowKey,
//                       'phone': phone,
//                     },
//                   );
//                 }),
//               ],
//               headerBuilder: headerIcon(Icons.phone),
//               sideBuilder: sideIcon(Icons.phone),
//             );
//           },
//           '/profile': (context) {
//             return const ProfilePage();
//           },
//           '/home': (context) => const Home(),
//           '/sign-up': (context) => const SignUp(),
//           '/create-invoice': (context) => CreateInvoice(),
//           '/month-invoice': (context) => const MonthInvoice(),
//           '/year-invoice': (context) => const YearInvoice(),
//           '/unkown': (context) => const Unkown(),
//         },
//         title: 'Best Inox',
//         theme: ThemeData(
//           primaryColor: const Color(0xFF93221E),
//           primarySwatch: buildMaterialColor(const Color(0xFF93221E)),
//         ),
//       ),
//     );
//   }
// }

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ProfileProvider? provider = ProfileProvider.instance;
//     return ProfileScreen(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () async {
//               final auth = FirebaseAuth.instance;
//               if (auth.currentUser != null) {
//                 if (provider?.profile == null) {
//                   await provider?.getProfile(auth.currentUser?.uid ?? "");
//                 }
//                 if (provider?.profile?.role == "admin") {
//                   Navigator.pushReplacementNamed(context, '/year-invoice');
//                 } else if (provider?.profile?.role == "stock") {
//                   Navigator.pushReplacementNamed(context, '/creat-invoice');
//                 } else {
//                   Navigator.pushReplacementNamed(context, '/unkown');
//                 }
//               } else {
//                 Navigator.pushReplacementNamed(context, '/sign-in');
//               }
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios_rounded,
//             )),
//       ),
//       actions: [
//         SignedOutAction((context) {
//           Navigator.pushReplacementNamed(context, '/');
//         }),
//       ],
//       showMFATile: true,
//     );
//   }
// }

class Unkown extends StatelessWidget {
  const Unkown({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF93221E),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/logo.svg",
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              "you don't have authentication to use this app",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              width: 200,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF93221E),
                    backgroundColor: Colors.white,
                  ),
                  // exit(0),
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed("/profile"),
                  child: const Text("close")),
            ),
          ],
        ),
      ),
    );
  }
}

// class SignIn extends StatelessWidget {
//   SignIn({Key? key}) : super(key: key);

//   final mfaAction = AuthStateChangeAction<MFARequired>(
//     (context, state) async {
//       final ProfileProvider? provider = ProfileProvider.instance;
//       final nav = Navigator.of(context);

//       UserCredential? user = await startMFAVerification(
//         resolver: state.resolver,
//         context: context,
//       );
//       Profile? p = await provider?.getProfile(user.user!.uid);
//       if (p?.role != null && p?.role == "admin") {
//         nav.pushReplacementNamed('/year-invoice');
//       } else if (p?.role != null && p?.role == "stock") {
//         nav.pushReplacementNamed('/create-invoice');
//       } else {
//         nav.pushReplacementNamed('/unkown');
//       }
//     },
//   );
//   @override
//   Widget build(BuildContext context) {
//     return SignInScreen(
//       actions: [
//         ForgotPasswordAction((context, email) {
//           Navigator.pushNamed(
//             context,
//             '/forgot-password',
//             arguments: {'email': email},
//           );
//         }),
//         VerifyPhoneAction((context, _) {
//           Navigator.pushNamed(context, '/phone');
//         }),
//         AuthStateChangeAction<SignedIn>((context, state) {
//           if (state.user?.uid == "JJbq9Ak30wUloakTheBSvpnSmzj1") {
//             Navigator.pushReplacementNamed(context, '/year-invoice');
//           } else {
//             Navigator.pushNamed(context, '/create-invoice');
//           }
//         }),
//         AuthStateChangeAction<UserCreated>((context, state) {
//           Navigator.pushReplacementNamed(context, '/profile');
//         }),
//         AuthStateChangeAction<CredentialLinked>((context, state) {
//           if (state.user.uid == "JJbq9Ak30wUloakTheBSvpnSmzj1") {
//             Navigator.pushReplacementNamed(context, '/year-invoice');
//           } else {
//             Navigator.pushNamed(context, '/create-invoice');
//           }
//         }),
//         mfaAction,
//       ],
//       styles: const {
//         EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
//       },
//       headerBuilder: headerImage('assets/images/best_inox.jpg'),
//       sideBuilder: sideImage('assets/images/best_inox.jpg'),
//       subtitleBuilder: (context, action) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 8),
//           child: Text(
//             action == AuthAction.signIn
//                 ? 'Welcome to Firebase UI! Please sign in to continue.'
//                 : 'Welcome to Firebase UI! Please create an account to continue',
//           ),
//         );
//       },
//       footerBuilder: (context, action) {
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 16),
//             child: Text(
//               action == AuthAction.signIn
//                   ? 'By signing in, you agree to our terms and conditions.'
//                   : 'By registering, you agree to our terms and conditions.',
//               style: const TextStyle(color: Colors.grey),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hey/ui/home_page.dart';
import 'package:hey/ui/login_page.dart';
import 'package:hey/ui/register_page.dart';
import 'package:hey/ui/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hey',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        SplashPage.path: (ctx) => const SplashPage(),
        RegisterPage.path: (ctx) => const RegisterPage(),
        LoginPage.path: (ctx) => const LoginPage(),
        HomePage.path: (ctx) => const HomePage()
      },
      initialRoute: HomePage.path,
    );
  }
}

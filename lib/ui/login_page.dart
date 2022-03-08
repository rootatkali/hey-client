import 'package:flutter/material.dart';
import 'package:hey/api/endpoints.dart';
import 'package:hey/model/login.dart';
import 'package:hey/ui/home_page.dart';
import 'package:hey/ui/register_page.dart';
import 'package:hey/util/constants.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _user = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hey'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _user,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Username'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: login,
                child: const Text('Log in'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: register,
                child: const Text('Not registered?'),
              ),
            )
          ],
        ),
      ),
    );
  }

  login() async {
    var login = Login(username: _user.text, password: _pass.text);
    logger.i(Endpoints.baseUrl);
    var user = await Constants.api.login(login);
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const HomePage()));
  }

  register() {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => RegisterPage()));
  }
}

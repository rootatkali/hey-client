import 'package:flutter/material.dart';
import 'package:hey/api/endpoints.dart';
import 'package:hey/model/login.dart';
import 'package:hey/model/user.dart';
import 'package:hey/ui/register_page.dart';
import 'package:hey/util/constants.dart';
import 'package:hey/util/log.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LoginPage extends StatefulWidget with Log {
  static const path = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _user = TextEditingController();
  final _pass = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // do not allow back button
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Hey'),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            // TODO make form with validation
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
                if (!_loading)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: login,
                      child: const Text('Log in'),
                    ),
                  ),
                if (!_loading)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: register,
                      child: const Text('Not registered?'),
                    ),
                  ),
                if (_loading)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const CircularProgressIndicator(),
                  )
              ],
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  login() async {
    final login = Login(username: _user.text, password: _pass.text); // model

    setState(() => _loading = true);
    final user = await (Constants.api.login(login).then((user) => user,
        onError: (_) => setState(() {
              _loading = false; // todo error message
            })));
    setState(() => _loading = false);

    Navigator.pop(context, user);
  }

  register() async {
    final callback = await Navigator.pushNamed(context, RegisterPage.path);

    if (callback is User) {
      Navigator.pop(context, callback);
    } else {
      widget.log.wtf('Register page callback not user: $callback');
    }
  }
}

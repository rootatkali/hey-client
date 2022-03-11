import 'package:flutter/material.dart';
import 'package:hey/api/cookie_interceptor.dart';
import 'package:hey/model/user.dart';
import 'package:hey/ui/login_page.dart';
import 'package:hey/util/constants.dart';
import 'package:hey/util/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget with Log {
  static const path = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(CookieInterceptor.key)) {
        // if logged in
        _fetchUser();
      } else {
        _login();
      }
    });
  }

  /// Opens login screen and waits for result
  _login() async {
    final user = await Navigator.pushNamed(context, LoginPage.path);

    if (user is User) {
      setState(() => _user = user);
    } else {
      // should never reach here
      widget.log.wtf('No user...');
      // todo more error?
      // try again
      _login();
    }
  }

  _fetchUser() async {
    var user = await Constants.api.getMe();

    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _user == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hey, ${_user!.name}'),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  )
                ],
              ),
      ),
    );
  }

  _logout() async {
    await Constants.api.logout();
    _login();
  }
}

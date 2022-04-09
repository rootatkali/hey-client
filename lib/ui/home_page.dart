import 'package:dio/dio.dart';
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

  /// Opens a new [LoginPage] and waits for result, which should be an instance
  /// of [User].
  void _login() async {
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

  void _fetchUser() async {
    try {
      var user = await Constants.api.getMe();

      setState(() {
        _user = user;
      });
    } on DioError catch (e) {
      widget.log.e('Web Error', e);
      _login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          'Hey, ${_user?.firstName ?? 'you'}', // TODO Replace 'Hey' with logo
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: _profile,
              child: Icon(
                // TODO Replace with pfp
                Icons.account_circle_outlined,
                color: Theme.of(context).primaryColorDark,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColorLight),
                shape: MaterialStateProperty.all(const CircleBorder()),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: _user == null
            ? const CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _generatePendingRequests(),
                  _generateFriendList(),
                  _generateSuggestions(),
                ],
              ),
      ),
    );
  }

  void _profile() {
    // TODO Implement profile page
    throw UnimplementedError();
  }

  void _logout() async {
    await Constants.api.logout();
    _login();
  }

  Widget _generatePendingRequests() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: const Text('New friend requests go here'),
    );
  }

  Widget _generateFriendList() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: const Text('Friend list goes here'),
    );
  }

  Widget _generateSuggestions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      child: const Text('Friend suggestions go here'),
    );
  }
}

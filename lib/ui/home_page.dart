import 'package:flutter/material.dart';
import 'package:hey/model/user.dart';
import 'package:hey/util/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
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
    Navigator.pop(context);
  }
}

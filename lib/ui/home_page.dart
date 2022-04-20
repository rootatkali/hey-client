import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hey/api/cookie_interceptor.dart';
import 'package:hey/api/endpoints.dart';
import 'package:hey/model/friend_view.dart';
import 'package:hey/model/user.dart';
import 'package:hey/ui/friend.dart';
import 'package:hey/ui/friend_page.dart';
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: _profile,
              child: Icon(
                // TODO Replace with CircleAvatar
                // Icons.account_circle_outlined,
                Icons.logout,
                color: Theme.of(context).primaryColorDark,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColorLight.withOpacity(0.6)),
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
            : ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
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
    // widget.log.i('Profile picture pressed');
    // throw UnimplementedError();
    _logout();
  }

  void _logout() async {
    await Constants.api.logout();
    _login();
  }

  Widget _generatePendingRequests() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('New friend requests go here'),
          Row(
            children: [
              // TODO Remove placeholder friend
              Friend(
                profilePicture: const NetworkImage(
                  Endpoints.placeholderImage,
                ),
                name: 'Placeholder',
                status: FriendStatus.online,
                callToAction: ElevatedButton(
                  onPressed: () => widget.log.i('Placeholder CTA pressed'),
                  child: const Text('hello'),
                ),
                onPressed: () => widget.log.i('Placeholder card pressed'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _generateFriendList() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: const Text('Friend list goes here'),
    );
  }

  Widget _generateSuggestions() {
    final scroll = ScrollController();

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggestions for you',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark, fontSize: 20),
          ),
          FutureBuilder<List<FriendView>>(
            future: _fetchSuggestions(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final list = snapshot.data!;

                if (list.isEmpty) {
                  return const Text(
                    'No suggestions at the moment. Come back later for more!',
                  );
                }

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: ListView.builder(
                    itemCount: list.length,
                    scrollDirection: Axis.horizontal,
                    controller: scroll,
                    itemBuilder: (ctx, index) {
                      final friend = snapshot.data![index];
                      return Friend(
                        profilePicture: const NetworkImage(
                          // TODO Replace
                          Endpoints.placeholderImage,
                        ),
                        name: friend.name,
                        status: FriendStatus.online, // TODO Implement status
                        onPressed: () => _openFriendPage(friend),
                        callToAction: ElevatedButton.icon(
                          icon: const Icon(Icons.person_add),
                          label: const Text('Add friend'),
                          onPressed: friend.status != 'FRIEND'
                              ? () {
                                  // TODO Add friend
                                  widget.log
                                      .i('CTA for suggestion ${friend.name}');
                                }
                              : null, // if already friend - button disabled
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(
                  snapshot.error!.toString(),
                  style: TextStyle(color: Colors.red[900]),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }

  Future<List<FriendView>> _fetchSuggestions() async {
    final callback = await Constants.api.getMatches();
    widget.log.i(callback);
    return callback;
  }

  void _openFriendPage(FriendView friend) {
    widget.log.i('Opening FriendPage for friend ${friend.name}');
    Navigator.pushNamed(context, FriendPage.path, arguments: friend);
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hey/api/cookie_interceptor.dart';
import 'package:hey/api/encryption.dart';
import 'package:hey/api/endpoints.dart';
import 'package:hey/model/friend_view.dart';
import 'package:hey/model/user.dart';
import 'package:hey/ui/chat_page.dart';
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

  late List<FriendView> _friends;
  late List<FriendView> _requests;
  late List<FriendView> _suggestions;

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
      KeyModule.generateKeys();

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

      KeyModule.generateKeys();

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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: _user == null
              ? const CircularProgressIndicator()
              : ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _generateSuggestions(),
                    _generatePendingRequests(),
                    _generateFriendList(),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    final friends = await _fetchFriends();
    final requests = await _fetchFriendRequests();
    final suggestions = await _fetchSuggestions();

    setState(() {
      _friends = friends;
      _requests = requests;
      _suggestions = suggestions;
    });
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
    final scroll = ScrollController();

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New friend requests for you',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark, fontSize: 20),
          ),
          FutureBuilder<List<FriendView>>(
            future: _fetchFriendRequests(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final list = snapshot.data!;

                _requests = list;

                if (list.isEmpty) {
                  return const Text(
                    'No friend requests for you... Come back later for more!',
                  );
                }

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 165,
                  child: ListView.builder(
                    itemCount: _requests.length,
                    scrollDirection: Axis.horizontal,
                    controller: scroll,
                    itemBuilder: (ctx, index) {
                      final friend = _requests[index];

                      return Friend(
                        profilePicture: const NetworkImage(
                          Endpoints.placeholderImage,
                        ),
                        name: friend.name,
                        status: FriendStatus.online,
                        onPressed: () => _openFriendPage(friend),
                        callToAction: _generateCta(friend),
                      );
                    },
                  ),
                );
              }  else if (snapshot.hasError) {
                return Text(
                  snapshot.error!.toString(),
                  style: TextStyle(color: Colors.red[900]),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _generateFriendList() {
    final scroll = ScrollController();

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your friends',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark, fontSize: 20),
          ),
          FutureBuilder<List<FriendView>>(
            future: _fetchFriends(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final list = snapshot.data!;
                _friends = list;

                if (list.isEmpty) {
                  return const Text(
                    "You haven't added any friend yet... Why not add some?",
                  );
                }

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 165,
                  child: ListView.builder(
                    itemCount: _friends.length,
                    scrollDirection: Axis.horizontal,
                    controller: scroll,
                    itemBuilder: (ctx, index) {
                      final friend = _friends[index];

                      return Friend(
                        profilePicture: const NetworkImage(
                          // TODO Replace
                          Endpoints.placeholderImage,
                        ),
                        name: friend.name,
                        status: FriendStatus.online, // TODO Implement status
                        onPressed: () => _openFriendPage(friend),
                        callToAction: _generateCta(friend),
                      );
                    },
                  ),
                );
              }  else if (snapshot.hasError) {
                return Text(
                  snapshot.error!.toString(),
                  style: TextStyle(color: Colors.red[900]),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
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
            'Friend suggestions for you',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark, fontSize: 20),
          ),
          FutureBuilder<List<FriendView>>(
            future: _fetchSuggestions(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final list = snapshot.data!;
                _suggestions = list;

                if (list.isEmpty) {
                  return const Text(
                    'No suggestions at the moment. Come back later for more!',
                  );
                }

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 165,
                  child: ListView.builder(
                    itemCount: _suggestions.length,
                    scrollDirection: Axis.horizontal,
                    controller: scroll,
                    itemBuilder: (ctx, index) {
                      final friend = _suggestions[index];
                      return Friend(
                        profilePicture: const NetworkImage(
                          // TODO Replace
                          Endpoints.placeholderImage,
                        ),
                        name: friend.name,
                        status: FriendStatus.online, // TODO Implement status
                        onPressed: () => _openFriendPage(friend),
                        callToAction: _generateCta(friend),
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

  Future<List<FriendView>> _fetchFriends() async {
    final callback = await Constants.api.getFriends();
    widget.log.i(callback);
    return callback;
  }

  Future<List<FriendView>> _fetchFriendRequests() async {
    final callback = await Constants.api.getPendingFriendRequests();
    widget.log.i(callback);
    return callback;
  }

  void _openFriendPage(FriendView friend) {
    widget.log.i('Opening FriendPage for friend ${friend.name}');
    Navigator.pushNamed(context, FriendPage.path, arguments: friend);
  }

  void _openChatPage(FriendView friend) {
    widget.log.i('Opening ChatPage for friend ${friend.name}');
    Navigator.pushNamed(context, ChatPage.path, arguments: friend);
  }

  Widget _generateCta(FriendView friend) {
    final ctas = <String, _Cta>{
      "STRANGER": _Cta("Add friend", Icons.person_add, (friend) async {
        final callback = await Constants.api.requestFriend(friend.id);
        _onRefresh();
      }),
      "PENDING": friend.initiated
          ? _Cta("Accept friend", Icons.favorite, (friend) async {
              final callback =
                  await Constants.api.approveFriendRequest(friend.id);
              _onRefresh();
            })
          : _Cta("Cancel request", Icons.person_add_disabled, (friend) async {
            widget.log.i('Cancel for ${friend.name} pressed');
            final callback = await Constants.api.deleteRequest(friend.id);
            _onRefresh();
          }),
      "FRIEND": _Cta("Chat", Icons.chat, (friend) {
        Navigator.pushNamed(context, ChatPage.path, arguments: friend);
      }),
      "REJECTED": _Cta("Add friend", Icons.person_add, null) // disabled button
    };

    final cta = ctas[friend.status!]!;

    final onPressed = cta.callback != null ? () => cta.callback!(friend) : null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          icon: Icon(cta.icon),
          label: Text(cta.title),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _Cta {
  final String title;
  final IconData icon;
  final void Function(FriendView)? callback;

  _Cta(this.title, this.icon, this.callback);
}

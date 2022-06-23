import 'package:flutter/material.dart';
import 'package:hey/ui/home_page.dart';

/// A template for the various friend lists on [HomePage].
///
/// This object requires the implementor to provide a [callToAction] widget, aka
/// button, for extra functionality (e.g. go to chat, accept friend request).
/// The [onPressed] function serves as a way for the implementor to navigate to
/// the friend's page.
// TODO Add link to FriendPage in doc comment
class Friend extends StatelessWidget {
  final ImageProvider<Object> profilePicture;
  final String name;
  final FriendStatus status;
  final void Function() onPressed;
  final Widget callToAction;

  const Friend(
      {Key? key, required this.profilePicture,
      required this.name,
      required this.status,
      required this.onPressed,
      required this.callToAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: status.color,
                radius: 35,
                child: CircleAvatar(
                  backgroundImage: profilePicture,
                  radius: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(name), // TODO Style
              ),
              callToAction
            ],
          ),
        ),
      ),
    );
  }
}

enum FriendStatus {
  online, away, doNotDisturb, offline
}

final _statusColors = <FriendStatus, Color>{
  FriendStatus.online: Colors.green.shade800,
  FriendStatus.away: Colors.amber.shade800,
  FriendStatus.doNotDisturb: Colors.red.shade900,
  FriendStatus.offline: Colors.white30,
};

extension on FriendStatus {
  Color get color => _statusColors[this]!;
}

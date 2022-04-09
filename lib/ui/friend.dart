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
  final Widget callToAction;
  final VoidCallback onPressed;

  const Friend(
      {Key? key,
      required this.profilePicture,
      required this.name,
      required this.callToAction,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorDark,
              radius: 35,
              child: CircleAvatar(
                backgroundImage: profilePicture,
                radius: 30,
              ),
            ),
            Padding( // TODO Insert status indicator
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(name), // TODO Style
            ),
            callToAction
          ],
        ),
      ),
    );
  }
}

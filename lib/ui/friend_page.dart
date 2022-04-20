import 'package:flutter/material.dart';
import 'package:hey/api/endpoints.dart';
import 'package:hey/model/friend_view.dart';
import 'package:hey/util/log.dart';
import 'package:intl/intl.dart' show NumberFormat;

// TODO Implement friend page
class FriendPage extends StatefulWidget with Log {
  static const path = '/friend';

  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    final friend = ModalRoute.of(context)!.settings.arguments as FriendView;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            pinned: true,
            expandedHeight: 300,
            automaticallyImplyLeading: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              centerTitle: true,
              title: Text(friend.name),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.network(
                    Endpoints.placeholderImage, // TODO Replace with pfp
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    // Gradient to go over pfp
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.5),
                        end: Alignment.center,
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                _divider(),
                // CTA
                _generateCta(friend),
                _divider(),

                // Bio
                _title('Bio'),
                _content(friend.bio),

                // School
                _title('School'),
                _content(
                  friend.school.name,
                  textDirection: TextDirection.rtl,
                ),

                // Grade
                _title('Grade'),
                _content(friend.grade.toString()),

                // Gender
                _title('Gender'),
                _content(friend.gender),

                // Hometown
                if (friend.hometown != null) ...[
                  _title('Hometown'),
                  _content(friend.hometown!),
                ],

                // Interests
                // TODO Replace with tags?
                _title('Interests'),
                ...friend.interests
                    .map((e) => _content(e.name, bottomPadding: 0))
                    .toList(),
                _divider(),

                // Distance
                _title('Distance'),
                _content(
                  '${NumberFormat('##0.0#').format(friend.distance)} km away',
                ),

                // Match score
                _title('Match score'),
                _content(
                  '${NumberFormat('##0.0#').format(friend.matchScore * 100)}%',
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _title(String text, {FontWeight fontWeight = FontWeight.w600}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: fontWeight),
      ),
    );
  }

  Widget _content(String text,
      {Color color = Colors.black54,
      TextDirection? textDirection,
      double bottomPadding = 8.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, bottomPadding),
      child: Text(
        text,
        style: TextStyle(color: color),
        textDirection: textDirection,
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Theme.of(context).canvasColor,
      height: 8,
    );
  }

  Widget _generateCta(FriendView friend) {
    // TODO Implement CTA
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: null,
          child: Text('CTA To be developed'),
        ),
      ),
    );
  }
}

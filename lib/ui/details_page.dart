import 'package:flutter/material.dart';
import 'package:hey/model/user.dart';
import 'package:hey/util/constants.dart';

class DetailsPage extends StatefulWidget {
  static const path = "/details";
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late User _user;
  final _bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context)!.settings.arguments as User;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Welcome, ${_user.firstName}'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "We'd like to hear more about you",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  minLines: 4,
                  decoration: const InputDecoration(labelText: 'Enter your bio'),
                  controller: _bio,
                ),
              ),
              // TODO Insert interests picker
              ElevatedButton(
                child: const Text('Done'),
                onPressed: _finish,
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }

  void _finish() async {
    final body = User(bio: _bio.text);
    final callback = await Constants.api.editMe(body);
    Navigator.pop(context, callback);
  }
}

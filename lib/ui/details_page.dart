import 'package:flutter/material.dart';
import 'package:hey/model/user.dart';
import 'package:hey/util/constants.dart';
import 'package:hey/util/log.dart';
import 'package:hey/util/step_advancer.dart';

class DetailsPage extends StatefulWidget with Log {
  static const path = "/details";
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int _step = 0;
  late User _user;
  final _bio = TextEditingController();
  final _address = <String, TextEditingController>{
    'street': TextEditingController(),
    'town': TextEditingController(),
  };

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
            children: <Widget>[
              const Text(
                "We'd like to hear more about you",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              Stepper(
                currentStep: _step,
                controlsBuilder: _controls,
                steps: <Step>[
                  Step(
                    title: const Text('Your address'),
                    content: Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Column(
                        children: <Widget>[
                          const Text('We need your address so we can find '
                              'friends who are close to you.'),
                          TextField(
                            controller: _address['street'],
                            decoration: const InputDecoration(
                                labelText: 'Street and number'),
                          ),
                          TextField(
                            controller: _address['town'],
                            decoration:
                                const InputDecoration(labelText: 'Town'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    title: const Text('Tell us about yourself'),
                    content: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      minLines: 4,
                      decoration:
                          const InputDecoration(labelText: 'Enter your bio'),
                      controller: _bio,
                    ),
                  ),
                  Step(
                    title: const Text('Your interests'),
                    content: Container(
                      // TODO Insert interests picker (autocomplete?)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }

  Widget _controls(BuildContext context, ControlsDetails details) {
    final step = details.stepIndex;

    final advance = <int, StepAdvancer>{
      0: StepAdvancer('Next', _submitAddress), // address select
      1: StepAdvancer('Next', () => setState(() => _step++)), // bio
      2: StepAdvancer('Done', _finish), // interests
    };

    final sa = advance[step]!;

    return Row(
      children: <Widget>[
        sa.asButton(),
        // todo cancel button?
      ],
    );
  }

  void _finish() async {
    final body = User(bio: _bio.text);
    final callback = await Constants.api.editMe(body);

    // TODO Submit interests

    Navigator.pop(context, callback);
  }

  void _submitAddress() async {
    final address = '${_address['street']!.text} ${_address['town']!.text}';
    final location = await Constants.locationService.fetchLocation(address);
    final locationCallback = await Constants.api.postLocation(location);
    widget.log.i(locationCallback);

    setState(() {
      _step++;
    });
  }
}

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hey/model/mashov_login.dart';
import 'package:hey/model/school.dart';
import 'package:hey/model/user.dart';
import 'package:hey/ui/details_page.dart';
import 'package:hey/util/constants.dart';
import 'package:hey/util/log.dart';
import 'package:hey/util/step_advancer.dart';

class VerifyPage extends StatefulWidget with Log {
  static const path = "/verify";

  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  int _step = 0;
  bool _loading = true;
  School? _selected;
  User? _callback;

  final _user = TextEditingController();
  final _pass = TextEditingController();

  late List<School> _schools;

  @override
  void initState() {
    super.initState();

    Constants.api.getSchools().then((schools) {
      setState(() {
        _schools = schools;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Verify your identity'),
        ),
        body: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : Stepper(
                  currentStep: _step,
                  controlsBuilder: _controls,
                  steps: <Step>[
                    Step(
                      title: const Text('Select your school'),
                      content: Container(
                        alignment: AlignmentDirectional.centerStart,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Autocomplete<School>(
                              displayStringForOption: (s) => s.name,
                              fieldViewBuilder:
                                  (context, controller, node, onSubmit) {
                                return TextField(
                                  controller: controller,
                                  focusNode: node,
                                  decoration: const InputDecoration(
                                      labelText: 'School'),
                                );
                              },
                              optionsBuilder: (value) {
                                if (value.text.isEmpty) {
                                  return const Iterable.empty();
                                }
                                return _schools.where(
                                    (s) => s.toString().contains(value.text));
                              },
                              onSelected: (selection) {
                                setState(() {
                                  _selected = selection;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Step(
                        title: const Text('Log in with Mashov'),
                        content: Container(
                          alignment: AlignmentDirectional.centerStart,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: _user,
                                decoration: const InputDecoration(
                                    labelText: 'Username'),
                              ),
                              TextField(
                                controller: _pass,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    labelText: 'Password'),
                              ),
                              // TODO add cpi
                            ],
                          ),
                        )),
                    Step(
                      title: const Text('Your details'),
                      content: Container(
                        alignment: AlignmentDirectional.centerStart,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: _callback == null
                              ? [const CircularProgressIndicator()]
                              : [
                                  Text("Gender: ${_callback!.gender}"),
                                  Text("Grade: ${_callback!.grade}"),
                                ],
                        ),
                      ),
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
      0: StepAdvancer("Next", _validateSchool), // school select
      1: StepAdvancer("Log in", _mashovLogin), // login to mashov
      2: StepAdvancer("Next", _advance), // next page
    };

    final sa = advance[step]!;

    return Row(
      children: <Widget>[
        ElevatedButton(onPressed: sa.onClick, child: Text(sa.text)),
        // todo cancel button?
      ],
    );
  }

  void _validateSchool() {
    if (_selected != null) {
      widget.log.i('School ${_selected!.id} selected');
      setState(() {
        _step++;
      });
    } else {
      widget.log.e('Error selecting school.');
    }
  }

  void _mashovLogin() async {
    const year = 2022;
    final semel = _selected!.id;
    final username = _user.text;
    final password = _pass.text;

    // if test login for mashov, manually set school and details
    if (kDebugMode && username == 'test' && password == 'test') {
      // Set user school
      await Constants.api.manuallySetSchool(_selected!);

      // Set user gender and grade
      final random = Random();
      final request = User(
        grade: random.nextInt(6) + 7,
        gender: 'MFOX'.characters.elementAt(random.nextInt(4)),
      );

      _callback = await Constants.api.editMe(request);

    } else {
      final login = MashovLogin(semel, year, username, password);

      _callback = await Constants.api.verifyMashov(login);
    }

    setState(() {
      _step++;
    });
  }

  void _advance() async {
    final callback = await Navigator.pushNamed(context, DetailsPage.path,
        arguments: _callback);
    if (callback is User) {
      Navigator.pop(context, callback);
    } else {
      widget.log.wtf('Details page callback not user: $callback');
    }
  }
}

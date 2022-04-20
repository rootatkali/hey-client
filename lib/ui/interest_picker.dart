import 'package:flutter/material.dart';
import 'package:hey/model/interest.dart';
import 'package:hey/util/constants.dart';
import 'package:hey/util/string_ext.dart';

/// This class has no [path] field, because it is not meant to be pushed
class InterestPicker extends StatefulWidget {
  const InterestPicker({Key? key}) : super(key: key);

  @override
  State<InterestPicker> createState() => _InterestPickerState();
}

class _InterestPickerState extends State<InterestPicker> {
  static const _newInterestPrefix = 'Create new interest ';
  static const _newInterestId = 'new';
  Set<Interest> _selected = {};
  late List<Interest> _available;

  @override
  void initState() {
    super.initState();

    Constants.api.getInterests().then((callback) => setState(() {
          _available = callback;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final selectedList = _selected.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick your interests'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveInterests,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Autocomplete<Interest>(
            displayStringForOption: (i) => i.name,
            fieldViewBuilder: (context, controller, node, onSubmit) {
              return TextField(
                controller: controller,
                focusNode: node,
                decoration: const InputDecoration(labelText: 'Interests'),
              );
            },
            optionsBuilder: (value) {
              if (value.text.isEmpty) {
                return const Iterable.empty();
              }

              // Filter interests by their id.
              final filtered = _available
                  .where((e) => e.name.containsIgnoreCase(value.text));
              // If no existing found, return new "interest" with unique id, so
              // the user can press it and create a new record in the server db.
              if (filtered.isEmpty) {
                return [
                  Interest(_newInterestId, '$_newInterestPrefix${value.text}')
                ];
              }
              // if the filtered list is not empty, return it.
              return filtered;
            },
            onSelected: _interestSelected,
          ),
          Flexible(
            child: ListView.separated(
              itemCount: _selected.isEmpty ? 1 : _selected.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                if (_selected.isEmpty) {
                  return const Text('No interests selected.');
                }
                return Text(selectedList[index].name);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _saveInterests() async {
    final callback = await Constants.api.setMyInterests(_selected.toList());

    Navigator.pop(context, callback);
  }

  void _interestSelected(Interest option) async {
    if (option.id == _newInterestId) {
      final name =
          option.name.replaceFirst(_newInterestPrefix, ''); // remove prefix

      option = await Constants.api.addInterest(name);
      _available.add(option); // for autocomplete
    }

    setState(() {
      _selected.add(option);
    });
  }
}

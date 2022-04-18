import 'package:flutter/material.dart';

class StepAdvancer {
  final String text;
  final void Function() onClick;

  const StepAdvancer(this.text, this.onClick);

  /// Returns a button representation of the step advancer.
  Widget asButton() => ElevatedButton(onPressed: onClick, child: Text(text));
}

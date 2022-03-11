import 'package:logger/logger.dart';
import 'package:hey/util/string_ext.dart';

/// Mixin implementing custom log printing
mixin Log {
  Logger get log => Logger(printer: CompactPrinter(runtimeType.toString()));
}

class CompactPrinter extends LogPrinter {
  final String source;

  CompactPrinter(this.source);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final levelLetter = event.level == Level.wtf
        ? '?'
        : event.level.name.substring(0, 1).toUpperCase();

    final lines = <String>[
      color!(
          '${emoji.isNullOrEmpty ? '' : '$emoji '}$source [$levelLetter]: ${event.message}')
    ];

    if (event.stackTrace != null) {
      lines.add(color(event.stackTrace.toString()));
    }

    return lines;
  }
}

class PlainPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return [
      event.message,
      if (event.stackTrace != null) event.stackTrace.toString()
    ];
  }
}

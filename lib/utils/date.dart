import 'package:intl/intl.dart';

String formatDt(DateTime dt, String? format) {
  String _format = format != null ? format : 'yyyy-MM-dd hh:mm';
  final DateFormat formatter = DateFormat(_format);
  return formatter.format(dt);
}

String formatTime(DateTime dt) {
  final DateFormat formatter = DateFormat('hh:mm a');
  return formatter.format(dt);
}
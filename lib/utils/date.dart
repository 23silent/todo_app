import 'package:intl/intl.dart';

String formatDt(DateTime dt, String? format) {
  String _format = format != null ? format : 'yyyy-MM-dd hh:mm';
  final DateFormat formatter = DateFormat(_format);
  return formatter.format(dt);
}
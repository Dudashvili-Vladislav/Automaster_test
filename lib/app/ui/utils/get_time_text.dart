import 'package:auto_master/app/constatns.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String getTimeText(String time) {
  final formattedTime = DateFormat('HH:mm:ss').parse(time);
  // final period = DateFormat.jm().format(formattedTime);

  // final isPm = period.split(' ').last.toLowerCase() == 'pm';

  return '${formattedTime.hour.toString().padLeft(2, '0')}:${formattedTime.minute.toString().padLeft(2, '0')}';
}

String getDate({required String dateFrom, String? dateTo}) {
  initializeDateFormatting();
  final dateFromParsed = dateFormatter.parse(dateFrom);
  final formmatter = DateFormat('dd MMMM', 'ru');
  if (dateTo != null) {
    final dateToParsed = dateFormatter.parse(dateTo);
    final from = formmatter.format(dateFromParsed);
    final to = formmatter.format(dateToParsed);
    final year = DateFormat('yyyy', 'ru').format(dateToParsed);
    if (from.split(' ').last == to.split(' ').last) {
      return '${from.split(' ').first}-$to\n$year года';
    } else {
      return '$from-$to\n$year года';
    }
  } else {
    final year = DateFormat('yyyy').format(dateFromParsed);
    return '${formmatter.format(dateFromParsed)}\n$year года';
  }
}

import 'package:auto_master/app/domain/models/adress_location.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final phoneFormatter = MaskTextInputFormatter(
  mask: '+7 (###) ###-##-##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.eager,
);

final phoneFormatterNew = MaskTextInputFormatter(
  mask: '(###) ###-##-##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.eager,
);

final carNumberMask = MaskTextInputFormatter(
  mask: '# @@@ ## @@@',
  filter: {"@": RegExp(r'[0-9]'), "#": RegExp(r'[А-я]')},
  type: MaskAutoCompletionType.eager,
);

final dateFormatter = DateFormat('yyyy-MM-dd');
final dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm');

String directionDetailsAPI(AddressLocation start, AddressLocation end) =>
    "https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}";

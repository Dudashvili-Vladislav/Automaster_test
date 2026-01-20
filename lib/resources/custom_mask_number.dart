import 'package:flutter/services.dart';

class CustomNumberMask extends TextInputFormatter {
  final String pattern;
  CustomNumberMask({this.pattern = ''});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var newText = '';

    // var sanitized = sanitize(newValue.text);

    // if (pattern.isEmpty) {
    //   return newValue.copyWith(text: sanitized);
    // }

    // var relativeIndex = nthIndex(pattern, '#', sanitized.length);
    // var nextIndex = relativeIndex + 1;

    // if (relativeIndex == -1 && sanitized.isNotEmpty) {
    //   return oldValue;
    // }

    // var trimmedFormat = pattern.substring(0, nextIndex);
    // var index = 0;

    // for (var i = 0; i < trimmedFormat.length; i++) {
    //   if (trimmedFormat[i] == '#') {
    //     if (index < sanitized.length) {
    //       newText.write(sanitized[index]);
    //       index++;
    //     }
    //   } else {
    //     newText.write(trimmedFormat[i]);
    //   }
    // }

    // var baseOffset = newValue.selection.baseOffset;
    // var inputLength = newValue.text.length;
    // var outputLength = newText.length;

    // var relativeOffset = (baseOffset + (outputLength - inputLength));
    if (newValue.text.length > 1 && newValue.text.length < 4) {
      if (oldValue.text.length < newValue.text.length) {
        newText = oldValue.text + sanitize(newValue.text);
      } else {
        newText = newValue.text;
      }
    } else {
      newText = newValue.text;
    }

    if (newValue.text.length == 1) {
      if (newValue.text.length > oldValue.text.length) {
        if (sanitizeWords(newValue.text).isEmpty) {
          newText = oldValue.text + sanitizeWords(newValue.text);
        } else {
          newText = '${oldValue.text}${sanitizeWords(newValue.text)} ';
        }
      } else {}
    }

    if (newValue.text.length == 5) {
      if (newValue.text.length > oldValue.text.length) {
        newText = '${newValue.text} ';
      }
    }
    if (newValue.text.length == 8) {
      if (newValue.text.length > oldValue.text.length) {
        newText = '${newValue.text} ';
      }
    }

    // if (oldValue.text.length == 8) {
    //   newText = newValue.text + ' ';
    // }

    return TextEditingValue(
      text: newText.toString(),
      // selection: TextSelection.collapsed(
      //   offset: 10,
      // ),
    );
  }

  String sanitize(String text) {
    return text.replaceAll(RegExp(r'[^0-9]+'), '');
  }

  String sanitizeWords(String text) {
    return RegExp(r'[a-zA-Zа-яА-Я\s]*')
        .allMatches(text)
        .map((match) => match.group(0))
        .join('');
  }
}

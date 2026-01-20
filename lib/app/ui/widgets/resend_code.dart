import 'dart:async';

import 'package:auto_master/app/domain/service/auth_service.dart';
import 'package:auto_master/app/ui/widgets/red_text_button.dart';
import 'package:flutter/material.dart';

class ResendCode extends StatefulWidget {
  const ResendCode({required this.phone, super.key});

  final String phone;

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ResendCode> {
  int secondsLeft = 30;

  Timer? timer;

  // String get clearPhone =>
  //     widget.phone.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '');

  @override
  void initState() {
    print('Init resendCode phone=${widget.phone}');
    super.initState();
    setTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void setTimer() {
    timer?.cancel();

    setState(() {
      secondsLeft = 30;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      print('Update resendCode $secondsLeft');
      if (mounted) {
        setState(() {
          secondsLeft--;
        });
        if (secondsLeft == 0) {
          timer?.cancel();
        }
      } else {
        timer?.cancel();
      }
    });
  }

  Widget getCall(BuildContext context) {
    if (secondsLeft > 1) {
      return RedTextButton(
        text: 'Запросить звонок повторно через $secondsLeft с',
      );
    } else {
      return RedTextButton(
        text: 'Запросить звонок',
        onPressed: () {
          setTimer();
          AuthService.getCode(context, widget.phone);
        },
      );
    }
  }

  Widget getSMS(BuildContext context) {
    if (secondsLeft > 1) {
      return RedTextButton(
        text: 'Запросить смс повторно через $secondsLeft с',
      );
    } else {
      return RedTextButton(
        text: 'Запросить смс',
        onPressed: () {
          setTimer();
          AuthService.getSMSCode(context, widget.phone);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build code phone=${widget.phone}');
    return Column(
      children: [
        getCall(context),
        // SizedBox(height: 8),
        getSMS(context),
      ],
    );
  }
}

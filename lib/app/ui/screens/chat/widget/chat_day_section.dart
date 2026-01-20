import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/ui/screens/chat/widget/chat_text_widget.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

final dateFormat = DateFormat('d MMMM', 'ru_RU');

class DaySection extends StatelessWidget {
  const DaySection({required this.dateTime, required this.messages, super.key});

  final DateTime dateTime;
  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    final timeText = dateFormat.format(dateTime);
    return StickyHeader(
      header: //const SizedBox(),
          Center(
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          height: 24.0,
          width: 100,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ]),
          alignment: Alignment.center,
          child: Text(
            timeText,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: AppColors.main,
            ),
          ),
        ),
      ),
      content: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ChatMessageWidget(
            chatMessage: messages[i],
          ),
        ),
        itemCount: messages.length,
      ),
    );
  }
}

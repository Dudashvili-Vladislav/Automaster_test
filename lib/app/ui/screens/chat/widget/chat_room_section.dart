import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/ui/screens/chat/widget/chat_day_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class ChatRoomSection extends StatelessWidget {
  const ChatRoomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) {
        Function eq = const ListEquality().equals;

        return !eq(previous.messages, current.messages);
      },
      builder: (context, state) {
        print(state.messages.length);
        final mapMessages = <String, List<ChatMessage>>{};
        for (final msg in state.messages) {
          final currentDateTime =
              DateTime(msg.dateTime.year, msg.dateTime.month, msg.dateTime.day);
          final cdts = currentDateTime.toString();
          if (mapMessages.containsKey(cdts)) {
            mapMessages[cdts]!.add(msg);
          } else {
            mapMessages[cdts] = [msg];
          }
        }
        final sortedMap = mapMessages.entries.toList();
        sortedMap.sort((a, b) {
          return a.key.compareTo(b.key);
        });
        final reversedMap = sortedMap.reversed.toList();
        return ListView.builder(
          reverse: true,
          itemBuilder: (context, index) {
            final entry = reversedMap[index];
            return DaySection(
              dateTime: DateTime.parse(entry.key),
              messages: entry.value,
            );
          },
          itemCount: reversedMap.length,
        );
      },
    );
  }
}

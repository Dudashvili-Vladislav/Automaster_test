import 'package:auto_master/app/ui/screens/chat/widget/chat_appbar.dart';
import 'package:auto_master/app/ui/screens/chat/widget/chat_room_section.dart';
import 'package:auto_master/app/ui/screens/chat/widget/chat_user_input.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ChatAppbar(),
            Flexible(
              child: ChatRoomSection(),
            ),
            ChatUserInput(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

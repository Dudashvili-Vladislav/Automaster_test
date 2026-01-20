import 'package:auto_master/app/ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AddAutoPattern extends StatelessWidget {
  const AddAutoPattern({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Добавление авто',
            ),
            Flexible(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

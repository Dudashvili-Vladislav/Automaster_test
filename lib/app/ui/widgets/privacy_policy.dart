import 'package:auto_master/app/ui/widgets/black_text_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BlackTextButton(
          text: 'Публичная оферта',
          onPressed: () => launchUrlString(
              'https://auto-master.pro/contract_offer.html',
              mode: LaunchMode.externalApplication),
        ),
        // const SizedBox(height: 8),
        BlackTextButton(
          text: 'Пользовательское соглашение',
          onPressed: () => launchUrlString(
              'https://auto-master.pro/terms_of_use.html',
              mode: LaunchMode.externalApplication),
        ),
      ],
    );
  }
}

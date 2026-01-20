import 'package:auto_master/app/data/error_handler.dart';
import 'package:auto_master/app/domain/models/accessories_entity.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';

import 'package:auto_master/app/ui/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'accessories_sub_list_page.dart';

class AccessoriesPage extends StatefulWidget {
  const AccessoriesPage({super.key});

  static const routeName = '/accessories';

  @override
  State<AccessoriesPage> createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  bool isLoading = false;
  bool buttonIsLoading = false;
  List<Accessories> accessories = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(loadAccessories);
  }

  Future<void> loadAccessories() async {
    isLoading = true;
    if (mounted) setState(() {});

    accessories = await CustomerService.getAccessories(context) ?? [];

    isLoading = false;
    if (mounted) setState(() {});
  }

  Future<void> loadLink() async {
    buttonIsLoading = true;
    if (mounted) setState(() {});

    final link = await CustomerService.getAccessoriesLink(context);

    if (link != null) {
      await launchWA(link);
    }

    buttonIsLoading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Авто б/у',
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                ),
                itemCount: accessories.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) => ServicesCard(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AccessoriesSubDetailPage(data: accessories[index]),
                    ),
                  ),
                  text: accessories[index].nameOfAccessoriesCategory,
                  image: accessories[index].avatarOfAccessoriesCategory ?? '',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 36.0,
              ),
              child: CustomButton(
                hasIcon: true,
                height: 47,
                text: 'Связаться со специалистом ',
                isLoading: buttonIsLoading,
                onPressed: loadLink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

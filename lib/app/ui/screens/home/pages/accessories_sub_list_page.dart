import 'package:auto_master/app/data/error_handler.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:auto_master/app/ui/screens/home/pages/accessories_detail_page.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/domain/models/accessories_entity.dart';

import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccessoriesSubDetailPage extends StatefulWidget {
  final Accessories data;
  const AccessoriesSubDetailPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<AccessoriesSubDetailPage> createState() =>
      _AccessoriesSubDetailPageState();
}

class _AccessoriesSubDetailPageState extends State<AccessoriesSubDetailPage> {
  bool buttonIsLoading = false;

  Future<void> loadLink() async {
    buttonIsLoading = true;
    if (mounted) setState(() {});

    final link = await CustomerService.getAccessoriesLink(context);

    if (link != null) {
      buttonIsLoading = false;
      if (mounted) setState(() {});
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
            CustomAppBar(
              title: widget.data.nameOfAccessoriesCategory,
            ),
            if (widget.data.list != null)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: widget.data.list!.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) => ServicesCard(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccessoriesDetailPage(
                            data: widget.data.list![index]),
                      ),
                    ),
                    text: widget.data.list![index].name,
                    image: widget.data.list![index].image ?? '',
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
                text: 'Связаться со специалистом',
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

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/customer/home_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_contacts_screen.dart';
import 'package:auto_master/app/ui/screens/home/pages/accessories_page.dart';
import 'package:auto_master/app/ui/screens/home/pages/select_sub_service.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = context.select((HomeState vm) => vm.specs);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Выберите раздел',
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                ),
                itemCount: services.length + 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemBuilder: (context, index) {
                  if (index == services.length) {
                    return ServicesCard(
                      text: 'Горячая\nлиния',
                      image: Images.redPhone,
                      isAsset: true,
                      onPressed: () {
                        final read = context.read<HomeState>();
                        read.selectSubCetegory('');
                        routemaster
                            .push('${AuthContactsScreen.routeNameShort}/false');
                        // Navigator.of(context, rootNavigator: true).push(
                        //   CupertinoPageRoute(
                        //     builder: (context) =>
                        //         const AuthContactsScreen(isAuth: false),
                        //   ),
                        // );
                      },
                    );
                  }
                  if (index == services.length + 1) {
                    return ServicesCard(
                      text: 'Авто б/у',
                      image: Images.accessories,
                      isAsset: true,
                      onPressed: () {
                        final read = context.read<HomeState>();
                        read.selectSubCetegory('');
                        routemaster.push(AccessoriesPage.routeName);
                      },
                    );
                  }
                  return ServicesCard(
                    text: services[index].nameOfCategory,
                    image: services[index].iconName,
                    onPressed: () {
                      final read = context.read<HomeState>();
                      read.selectSubCetegory('');
                      context.read<HomeState>().selectSpec(services[index]);
                      if (services[index].listOfSubCategory != null &&
                          services[index].listOfSubCategory!.isNotEmpty) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const SelectSubService(),
                          ),
                        );
                      } else {
                        routemaster.push(AppRoutes.selectAuto);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

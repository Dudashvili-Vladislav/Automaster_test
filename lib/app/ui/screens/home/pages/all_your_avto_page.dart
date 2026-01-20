import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/body_type.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/customer/home_state.dart';
import 'package:auto_master/app/domain/states/customer/profile_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

class AllYourAvtoPage extends StatefulWidget {
  const AllYourAvtoPage({super.key});

  @override
  State<AllYourAvtoPage> createState() => _AllYourAvtoPageState();
}

class _AllYourAvtoPageState extends State<AllYourAvtoPage> {
  List<BodyTypes> bodyTypes = [];
  bool isLoading = false;

  Future<void> getBodyList(BuildContext context) async {
    isLoading = true;
    if (mounted) setState(() {});

    final result = await CustomerService.getBodyList(context);

    if (result != null) {
      bodyTypes = result;
    }

    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    Future.microtask(() => getBodyList(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cars = context.select((CustomerProfileState vm) => vm.cars);
    final read = context.read<HomeState>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Все ваши авто',
              onBack: () => routemaster
                  .popUntil((routeData) => routeData.path == AppRoutes.home),
            ),
            isLoading
                ? const Loading()
                : Expanded(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 30),
                        Text(
                          'Выберете автомобиль, для\nкоторого хотите создать заявку',
                          style: AppTextStyle.s14w400.copyWith(
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 32)
                                .copyWith(bottom: 48, top: 5),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 20),
                            itemCount: cars.length,
                            itemBuilder: (context, index) {
                              // String imageUrl = '';

                              // try {
                              //   imageUrl =
                              //       '${ApiClient.baseImageUrl}${bodyTypes.firstWhere((element) => element.bodyType == cars[index].bodyType).icon}';
                              // } catch (_) {}

                              // https://sdskanban.ru/cards/1183341732524197524
                              final car = cars[index];
                              if ((read.selectedSpec?.nameOfCategory
                                          .toLowerCase()
                                          .contains('разбор') ??
                                      false) &&
                                  car.vinNumber.isEmpty &&
                                  car.carNationality ==
                                      'Иностранный автомобиль') {
                                return CrutchRazborCarCard(
                                  image:
                                      '${ApiClient.baseImageUrl}${cars[index].icon}',
                                  title:
                                      '${cars[index].brand} ${cars[index].model}',
                                  type: cars[index].bodyType ?? '',
                                  onPressed: () {
                                    read.selectAuto(cars[index]);
                                    routemaster.push(AppRoutes.createRequest);
                                  },
                                );
                              }

                              return CustomCarCard(
                                image:
                                    '${ApiClient.baseImageUrl}${cars[index].icon}',
                                title:
                                    '${cars[index].brand} ${cars[index].model}',
                                type: cars[index].bodyType ?? '',
                                onPressed: () {
                                  read.selectAuto(cars[index]);
                                  routemaster.push(AppRoutes.createRequest);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class CrutchRazborCarCard extends StatelessWidget {
  const CrutchRazborCarCard({
    Key? key,
    required this.onPressed,
    this.title = 'All New Terios',
    this.type = 'Внедорожник',
    required this.image,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final String type;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Внимание, для более точного подбора запчасти, обязательно укажите VIN код вашего автомобиля.',
          style: AppTextStyle.s14w400.copyWith(
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        CustomCarCard(
          title: title,
          type: type,
          image: image,
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class CustomCarCard extends StatelessWidget {
  const CustomCarCard({
    Key? key,
    required this.onPressed,
    this.title = 'All New Terios',
    this.type = 'Внедорожник',
    required this.image,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final String type;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: 327,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: AppColors.black.withOpacity(
              .25,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.s16w600.copyWith(
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            type,
            style: AppTextStyle.s12w500.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: CachedNetworkImage(
              imageUrl: image,
              // width: double.infinity,
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 36,
                width: 100,
                child: CupertinoButton(
                  color: AppColors.main,
                  borderRadius: BorderRadius.circular(60),
                  padding: EdgeInsets.zero,
                  onPressed: onPressed,
                  child: Text(
                    'Выбрать',
                    style: AppTextStyle.s12w600.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

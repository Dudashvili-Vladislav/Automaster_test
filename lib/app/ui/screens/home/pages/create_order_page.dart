import 'package:auto_master/app/data/api_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/customer/home_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeState>().fetchMasters());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeState>();
    final read = context.read<HomeState>();
    final masters = state.mastersBySpec;
    final mastersLength = masters.length < 6 ? masters.length : 5;
    final avatars = masters.where((e) => e.avatarUrl != null).toList();
    final car = read.selectedCar!;
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: state.isLoading
            ? const Loading()
            : SafeArea(
                child: Column(
                  children: [
                    const CustomAppBar(
                      title: 'Создание заявки',
                    ),
                    Expanded(
                      child: ListView(
                        physics: const RangeMaintainingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 10.0,
                        ),
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: AppColors.main,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 17),
                                    Text(
                                      state.selectedSubCategory?.isNotEmpty ??
                                              false
                                          ? state.selectedSubCategory!
                                          : state.selectedSpec
                                                  ?.nameOfCategory ??
                                              '',
                                      style: AppTextStyle.s12w600.copyWith(
                                        color: AppColors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (avatars.isNotEmpty)
                                      avatars.length == 1
                                          ? ImageMaster(
                                              avatar: avatars.first.avatarUrl,
                                            )
                                          : avatars.isEmpty
                                              ? const SizedBox.shrink()
                                              : Center(
                                                  child: SizedBox(
                                                    width: avatars.length *
                                                        (36.0 - avatars.length),
                                                    height: 44.0,
                                                    child: Stack(
                                                      children: List.generate(
                                                        avatars.length,
                                                        (index) => Positioned(
                                                          left: 24.0 * index,
                                                          child: ImageMaster(
                                                            avatar:
                                                                avatars[index]
                                                                    .avatarUrl,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                    if (mastersLength >= 1)
                                      const SizedBox(height: 9),
                                    Text(
                                      '${masters.length} мастеров',
                                      style: AppTextStyle.s12w600.copyWith(
                                        color: AppColors.main,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      'В данной специальности',
                                      style: AppTextStyle.s10w400.copyWith(
                                        color: AppColors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 9),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                // width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(.25),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  maxLines: 2,
                                  minLines: 1,
                                  controller: controller,
                                  cursorColor: AppColors.main,
                                  onChanged: (v) {
                                    if (mounted) setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 22.0,
                                      vertical: 16.0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: AppColors.main,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Опишите вашу проблему...',
                                    hintStyle: AppTextStyle.s14w400.copyWith(
                                      color: const Color(0xFFB6B6B6),
                                    ),
                                  ),
                                ),
                              ),
                              if ((read.selectedSpec?.nameOfCategory
                                          .toLowerCase()
                                          .contains('разбор') ??
                                      false) &&
                                  car.vinNumber.isEmpty &&
                                  car.carNationality ==
                                      'Иностранный автомобиль')
                                const Padding(
                                  padding: EdgeInsets.only(top: 24),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Пожалуйста, укажите VIN, чтобы мастер понял, что вы ищете',
                                      style: AppTextStyle.s12w400,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),
                              CustomButton(
                                width: 234,
                                height: 47,
                                text: 'Далее',
                                onPressed: controller.text.trim().isEmpty
                                    ? null
                                    : () {
                                        read.setProblem(controller.text.trim());
                                        routemaster.push(AppRoutes.selectDate);
                                      },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class ImageMaster extends StatelessWidget {
  const ImageMaster({
    Key? key,
    this.avatar,
  }) : super(key: key);
  final String? avatar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          imageUrl: '${ApiClient.baseImageUrl}$avatar',
          width: 44.0,
          height: 44.0,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            color: AppColors.main,
          ),
        ),
      ),
    );
  }
}

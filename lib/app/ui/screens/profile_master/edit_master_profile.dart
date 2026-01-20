import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/models/address.dart';
import 'package:auto_master/app/domain/service/master_service.dart';
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/ui/screens/profile/pages/profile_edit_page.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/dialogs/confirm_delete.dart';
import 'package:auto_master/app/ui/widgets/dialogs/confirm_phone.dart';

import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class EditMasterProfilePage extends StatefulWidget {
  const EditMasterProfilePage({Key? key}) : super(key: key);

  static String routeName = '/edit_master_profile';

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EditMasterProfilePage> {
  final pageNames = const ['О себе', 'Категории', 'Машины', 'Место работы'];
  static final pages = [
    const AboutMePage(),
    const CategoryPage(),
    const CarsPage(),
    const WorkInfoPage()
  ];

  int selectedPage = 0;

  Future<void> saveProfile(BuildContext context) async {
    final read = context.read<MasterProfileState>();
    // final readCPS = context.read<CustomerProfileState>();
    final selectedType = read.selectedSpec;
    final selectedSubCat = read.selectedSubCategory;
    print('selected subcat = $selectedSubCat ${selectedSubCat.runtimeType}');

    if (selectedType?.listOfSubCategory != null &&
        selectedType!.listOfSubCategory!.isNotEmpty &&
        selectedSubCat == null) {
      Fluttertoast.showToast(msg: 'Не выбрана подкатегория');
      return;
    }

    // Transform phone text to server format
    final newPhone =
        '+7${read.phoneController.text.trim().replaceAll(' ', '')}';

    if (newPhone.length != 16) {
      Fluttertoast.showToast(msg: 'Неверый ввод номера телефона');
      return;
    }

    print('newPhone=$newPhone, oldPhone = ${read.profile!.phone}');
    // print(read.phoneController.text);
    // print(newPhone);
    // print(read.profile!.phone);
    if (newPhone != read.profile!.phone) {
      print('Phone changed');
      final notExistPhone = await read.checkPhone(showMsg: true);
      print('Phone notExistPhone=$notExistPhone');

      if (notExistPhone) {
        print('Show confirm phone');
        confirmPhoneDialog(
          context,
          (v) async {
            final result = await read.checkCode(v);

            if (result) {
              read.updateProfile(
                context,
                image: read.imagePath,
                changePhone: true,
              );
            }
          },
          newPhone,
        );
      }
    } else {
      read.updateProfile(context, image: read.imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final state = context.watch<MasterProfileState>();
    // final read = context.read<MasterProfileState>();
    return Consumer<MasterProfileState>(
      builder:
          (BuildContext context, MasterProfileState state, Widget? child) =>
              GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: true,
            leading: CustomIconButton(
              onPressed: () => routemaster.history.back(),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // AppBar(
                //     // backgroundColor: Colors.transparent,
                //     ),
                Expanded(
                  child: ListView(
                    physics: const RangeMaintainingScrollPhysics(),
                    // padding: const EdgeInsets.symmetric(vertical: 8.0),
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 40),
                          AvatarPicker(
                            avatarUrl: state.profile?.avatarUrl,
                            onPickImage: (v) => state.onImagePicked(v),
                            imageData: state.imagePath?.data,
                          ),
                          state.profile?.avatarUrl == null
                              ? const SizedBox(width: 40.0)
                              : CustomIconButton(
                                  icon: Svgs.trash,
                                  onPressed: () async {
                                    final result =
                                        await showDeleteConfirm(context);

                                    if (result != null) {
                                      await state.deleteAvatar();
                                    }
                                  },
                                )
                        ],
                      ),
                      const SizedBox(
                        height: 38.0,
                      ),
                      SizedBox(
                        height: 51.0,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 36.0),
                          itemCount: pages.length,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12.0),
                          itemBuilder: (context, index) {
                            final isActivePage = selectedPage == index;
                            return CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  selectedPage = index;
                                });
                                // try {
                                //   Fluttertoast.showToast(msg: 'click $index');
                                //   state.onChangePage(index);
                                // } on Object catch (e) {
                                //   Fluttertoast.showToast(msg: e.toString());
                                // }
                              },
                              child: AnimatedContainer(
                                duration: kThemeAnimationDuration,
                                height: 41.0,
                                padding: const EdgeInsets.symmetric(
                                  // vertical: 12.0,
                                  horizontal: 24.0,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(57),
                                  color: Colors.white,
                                  border: isActivePage
                                      ? Border.all(
                                          width: 2,
                                          color: AppColors.main,
                                        )
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      color: isActivePage
                                          ? AppColors.red
                                          : Colors.black.withOpacity(.25),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  pageNames[index],
                                  style: AppTextStyle.s14w400.copyWith(
                                    color: isActivePage
                                        ? AppColors.main
                                        : AppColors.black,
                                    fontWeight: isActivePage
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 39.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            pages[selectedPage],
                            const SizedBox(height: 40.0),
                            // if (state.selectedPage == 3)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 32.0),
                                child: CustomButton(
                                  text: 'Сохранить',
                                  width: 213.0,
                                  isLoading: state.isLoading,
                                  onPressed: () => saveProfile(context),
                                ),
                              ),
                            ),
                            // if (state.selectedPage == 3)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        AppColors.main.withOpacity(.4),
                                  ),
                                  onPressed: () {
                                    confirmDeleteDialog(
                                      context,
                                      () => state.deleteProfile(),
                                    );
                                  },
                                  child: Text(
                                    'Удалить профиль',
                                    style: AppTextStyle.s14w400.copyWith(
                                      color: AppColors.main,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // if (state.selectedPage != 3)
                //   Column(
                //     mainAxisSize: MainAxisSize.min,
                //     children: <Widget>[
                //       Padding(
                //         padding: const EdgeInsets.only(bottom: 32.0),
                //         child: CustomButton(
                //           text: 'Сохранить',
                //           width: 213.0,
                //           isLoading: state.isLoading,
                //           onPressed: () => saveProfile(context),
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(bottom: 10.0),
                //         child: TextButton(
                //           style: TextButton.styleFrom(
                //             foregroundColor: AppColors.main.withOpacity(.4),
                //           ),
                //           onPressed: () {
                //             confirmDeleteDialog(
                //               context,
                //               () => read.deleteProfile(),
                //             );
                //           },
                //           child: Text(
                //             'Удалить профиль',
                //             style: AppTextStyle.s14w400.copyWith(
                //               color: AppColors.main,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WorkInfoPage extends StatefulWidget {
  const WorkInfoPage({
    super.key,
  });

  @override
  State<WorkInfoPage> createState() => _WorkInfoPageState();
}

class _WorkInfoPageState extends State<WorkInfoPage> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  late TextEditingController experienceController;
  late TextEditingController addressController;
  final addressNode = FocusNode();

  List<Address> _address = [];

  void onSearch(String query) async {
    _address.clear();

    final cities = await MasterService.searchAdress(context, query);

    if (cities != null) {
      _address = cities;
    }

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final read = context.read<MasterProfileState>();
    final address = read.selectedAddress;

    addressController = TextEditingController(text: address);
    experienceController = TextEditingController(
        text: read.selectedExperience ?? read.profile?.experience ?? '');

    nameController.text = read.serviceName ?? '';
    descController.text = read.serviceDesc ?? '';

    addressController.addListener(() {
      final query = addressController.text.trim();
      if (query.isNotEmpty && query.length >= 3) {
        Future.delayed(
          const Duration(seconds: 1),
          () => onSearch(query),
        );
      }
    });
  }

  @override
  void dispose() {
    addressController.removeListener(() {
      final query = addressController.text.trim();
      if (query.isNotEmpty && query.length >= 3) {
        Future.delayed(
          const Duration(seconds: 1),
          () => onSearch(query),
        );
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<MasterProfileState>();
    final read = context.read<MasterProfileState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(
            left: 20,
            bottom: 7.0,
          ),
          child: Text('Укажите стаж работы'),
        ),
        CustomInput(
          scrollPadding: 100,
          controller: experienceController,
          hintText: 'Укажите стаж работы',
          onChange: (v) => read.setExperience(v.isEmpty ? null : v),
        ),
        const SizedBox(height: 37),
        const Padding(
          padding: EdgeInsets.only(
            left: 20,
            bottom: 7.0,
          ),
          child: Text('Укажите название вашей работы'),
        ),
        CustomInput(
          scrollPadding: 100,
          controller: nameController,
          hintText: 'Укажите название вашей работы',
          onChange: (v) => read.setServiceName(v.isEmpty ? null : v),
        ),
        const SizedBox(height: 37),
        const Padding(
          padding: EdgeInsets.only(
            left: 20,
            bottom: 7.0,
          ),
          child: Text('Укажите адрес вашей работы'),
        ),
        SearchInput(
          node: addressNode,
          controller: addressController,
          hint: 'Укажите адрес вашей работы',
          onTap: (i) {
            read.setAddress((i.item as Address).value);
            addressController.text = (i.item as Address).value;

            FocusScope.of(context).unfocus();
          },
          suggestions: List.generate(
            _address.length,
            (index) => SearchFieldListItem(
              index.toString(),
              item: _address[index],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(_address[index].value),
              ),
            ),
          ),
        ),
        const SizedBox(height: 37),
        const Padding(
          padding: EdgeInsets.only(
            left: 20,
            bottom: 7.0,
          ),
          child: Text('Укажите описание'),
        ),
        Container(
          width: double.infinity,
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
            maxLines: 8,
            minLines: 6,
            controller: descController,
            cursorColor: AppColors.main,
            onChanged: (v) => read.setServiceDesc(v.isEmpty ? null : v),
            scrollPadding: const EdgeInsets.only(bottom: 150),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 25.0,
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
              hintText: 'Укажите описание...',
              hintStyle: AppTextStyle.s14w400.copyWith(
                color: const Color(0xFFB6B6B6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CarsPage extends StatefulWidget {
  const CarsPage({
    super.key,
  });

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  bool isActive = false;
  int? currentChek;
  final items = const [
    'Российский автомобиль',
    'Иностранный автомобиль',
    'Все автомобили',
  ];

  void toggle() {
    isActive = !isActive;
    setState(() {});
  }

  void selectCheck(newIndex) {
    currentChek = newIndex;
    context.read<MasterProfileState>().selectCarType(items[newIndex]);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final cartType = context.read<MasterProfileState>().selectedCarType;
    if (cartType != null) {
      final index = items.indexOf(cartType);
      currentChek = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(
            left: 20,
            bottom: 7.0,
          ),
          child: Text('Выберете авто'),
        ),
        CustomSelect(
          values: items,
          isActive: isActive,
          onPressed: () => toggle(),
          currentCheck: currentChek,
          onTap: (v) => selectCheck(v),
        ),
      ],
    );
  }
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    super.key,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isCategoryActive = false;
  bool isSubCategoryActive = false;
  int? currentChekCategory;
  int? currentChekSubcategory;

  void toggle(bool isCategory) {
    if (isCategory) {
      isCategoryActive = !isCategoryActive;
    } else {
      isSubCategoryActive = !isSubCategoryActive;
    }
    setState(() {});
  }

  void selectCheckCategory(newIndex) {
    currentChekCategory = newIndex;
    final newSpec = context.read<MasterProfileState>().specs[newIndex];
    context.read<MasterProfileState>().selectSpec(newSpec);
    currentChekSubcategory = null;
    setState(() {});
  }

  void selectCheckSubCategory(newIndex) {
    currentChekSubcategory = newIndex;
    final newSubCategory = context
        .read<MasterProfileState>()
        .selectedSpec!
        .listOfSubCategory![newIndex];
    context.read<MasterProfileState>().selectSubCategory(newSubCategory);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final read = context.read<MasterProfileState>();

    if (read.specs.isEmpty) {
      Future.microtask(() async {
        await read.getSpecs();
        if (mounted) setState(() {});
      });
    }
    currentChekCategory = read.selectedSpec == null
        ? null
        : read.specs.indexOf(read.selectedSpec!);
    if (read.selectedSubCategory != null &&
        (read.selectedSpec?.listOfSubCategory
                ?.contains(read.selectedSubCategory) ??
            false)) {
      currentChekSubcategory = read.selectedSpec?.listOfSubCategory
          ?.indexOf(read.selectedSubCategory!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MasterProfileState>();
    final read = context.read<MasterProfileState>();
    final selectedType = state.selectedSpec;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(
            left: 20,
            bottom: 7.0,
          ),
          child: Text('Категория'),
        ),
        CustomSelect(
          isActive: isCategoryActive,
          onPressed: () => toggle(true),
          onTap: selectCheckCategory,
          currentCheck: currentChekCategory,
          values: read.specs.map((e) => e.nameOfCategory).toList(),
        ),
        const SizedBox(height: 37.0),
        if (selectedType?.listOfSubCategory != null &&
            selectedType!.listOfSubCategory!.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              bottom: 7.0,
            ),
            child: Text('Подкатегория'),
          ),
        if (selectedType?.listOfSubCategory != null &&
            selectedType!.listOfSubCategory!.isNotEmpty)
          CustomSelect(
            isActive: isSubCategoryActive,
            onPressed: () => toggle(false),
            currentCheck: currentChekSubcategory,
            onTap: selectCheckSubCategory,
            values: selectedType.listOfSubCategory!,
            title: 'Выберите подкатегорию',
          ),
      ],
    );
  }
}

class AboutMePage extends StatelessWidget {
  const AboutMePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MasterProfileState>();
    final read = context.read<MasterProfileState>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Введите ваше имя',
            style: AppTextStyle.s14w400.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
        const SizedBox(height: 7),
        CustomInput(
          controller: read.nameController,
          hasFocus: state.nameHasFocus,
          node: read.nameNode,
        ),
        const SizedBox(height: 37),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Ваш номер телефона',
            style: AppTextStyle.s14w400.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
        const SizedBox(height: 7),
        IgnorePointer(
          ignoring: false,
          child: CustomInput(
            scrollPadding: 300,
            onlyRead: false,
            isPhone: true,
            controller: read.phoneController,
            node: read.phoneNode,
            formatters: [phoneFormatterNew],
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }
}

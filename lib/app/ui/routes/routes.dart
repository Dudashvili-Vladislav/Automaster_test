import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/domain/states/customer/home_state.dart';
import 'package:auto_master/app/domain/states/customer/orders_state.dart';
import 'package:auto_master/app/domain/states/customer/profile_state.dart';
import 'package:auto_master/app/domain/states/login_state.dart';
import 'package:auto_master/app/domain/states/master/master_orders_state.dart';
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_master/auth_profile_edit.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_master/auth_service_description.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_contacts_screen.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_forgot_enter_phone_screen.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_login_screen.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_new_password_screen.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_password_recovery.dart';
import 'package:auto_master/app/ui/screens/chat/chat_screen.dart';
import 'package:auto_master/app/ui/screens/chat/widget/chat_text_widget.dart';
import 'package:auto_master/app/ui/screens/home/home_screen.dart';
import 'package:auto_master/app/ui/screens/home/pages/accessories_page.dart';
import 'package:auto_master/app/ui/screens/home/pages/all_avto_page.dart';
import 'package:auto_master/app/ui/screens/home/pages/all_services_page.dart';
import 'package:auto_master/app/ui/screens/home/pages/all_your_avto_page.dart';
import 'package:auto_master/app/ui/screens/home/pages/category_selection_page.dart';
import 'package:auto_master/app/ui/screens/home/pages/create_order_page.dart';
import 'package:auto_master/app/ui/screens/home/pages/order_date_page.dart';

import 'package:auto_master/app/ui/screens/home/pages/select_distance_page.dart';
import 'package:auto_master/app/ui/screens/home/pages/select_sub_service.dart';
import 'package:auto_master/app/ui/screens/home_master/home_master_screen.dart';
import 'package:auto_master/app/ui/screens/order/order_screen.dart';
import 'package:auto_master/app/ui/screens/order/pages/all_hisotry_orders_page.dart';
import 'package:auto_master/app/ui/screens/order/pages/review_master_page.dart';
import 'package:auto_master/app/ui/screens/order/pages/review_now_master_page.dart';
// import 'package:auto_master/app/ui/screens/order/pages/review_master_page.dart';
// import 'package:auto_master/app/ui/screens/order/pages/review_now_master_page.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_avto_page.dart';
import 'package:auto_master/app/ui/screens/profile/pages/profile_edit_page.dart';
import 'package:auto_master/app/ui/screens/profile/profile_screen.dart';
import 'package:auto_master/app/ui/screens/profile_master/edit_master_profile.dart';
import 'package:auto_master/app/ui/screens/profile_master/profile_master_screen.dart';
import 'package:auto_master/app/ui/screens/screens.dart';
import 'package:auto_master/app/ui/screens/tabbar/master_tabbar_screen.dart';
import 'package:auto_master/app/ui/screens/tabbar/tabbar_screen.dart';
import 'package:auto_master/app/ui/screens/webview_payment.dart';
import 'package:auto_master/app/ui/widgets/camera_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart' as routemaster;

import '../screens/profile/pages/add_auto_first_page.dart';
import 'transition_page.dart';

const _splash = '/';
const _auth = '/auth';
const _login = '$_auth/login';
const _forgotEnterPhone = '$_login/forgot-phone';
// const _forgotVerify = '$_forgotEnterPhone/forgot-verify';
// const _forgotSetPass = '$_forgotVerify/forgot-set-pass';
// const _forgotSuccess = '$_forgotSetPass/forgot-success';
const _registerVerify = '$_auth/verify';
const _registerChoose = '$_registerVerify/choose';

// Client
const _registerClientSetPass = '$_registerChoose/set-pass';

// Master
const _registerMasterSetSpec = '$_registerChoose/set-spec';
const _registerMasterSetAutoService = '$_registerMasterSetSpec/set-service';
const _registerMasterSelectCars = '$_registerMasterSetAutoService/select-car';
const _registerMasterSetAbout = '$_registerMasterSelectCars/set-about';
const _registerMasterSetAboutServices =
    '$_registerMasterSetAbout/set-about-services';
const _registerMasterSetAvatar = '$_registerMasterSetAboutServices/set-avatar';

const _masterTabbar = '/master';
const _masterOrders = '$_masterTabbar/orders';
const _masterChat = '$_masterTabbar/chat';
const _masterProfile = '$_masterTabbar/profile';
const _masterUserProfile = '$_masterProfile/user';
const _masterEditProfile = '$_masterProfile/edit';
const _masterEditSpec = '$_masterProfile/edit-spec';
const _masterEditAutoService = '$_masterEditSpec/edit-service';
const _masterEditCars = '$_masterEditAutoService/edit-car';
const _masterEditAvatar = '$_masterEditCars/edit-avatar';
const _masterEditAbout = '$_masterEditCars/edit-about';
const _masterEditAboutService = '$_masterEditAbout/edit-about-service';
const _masterEditWorkAvatar = '$_masterEditAboutService/work-avatar';

const _clientTabbar = '/';

// Home
const _home = '/home';
const _selectCategory = '$_home/select-cateogry';
const _selectAuto = '$_selectCategory/select-auto';
const _createRequest = '$_selectAuto/create-request';
const _selectDate = '$_createRequest/select-date';
const _selectTime = '$_selectDate/select-time';
const _selectKM = '$_selectTime/select-km';
const _allAuto = '$_home/all-auto';
const _allServices = '$_home/all-services';
const _accessories = '$_allServices/accessories';
const _accessoriesDetail = '$_accessories/detail';
const _selectSubcategory = '$_home/select-subcategory';

// Orders
const _clientOrders = '/orders';
const _clientHistoryOrders = '$_clientOrders/history-orders';
const _clientPayOrder = '$_clientOrders/pay-order';
const _clientAllOrders = '$_clientOrders/all-orders';
const _clientOrderDetail = '$_clientOrders/detail';
const _clientOrderMap = '$_clientOrderDetail/map';
const _clientReviewOrder = '$_clientOrders/review-order';
const _clientReviewOrderNow = '$_clientReviewOrder/review-now';

// Profile
const _clientProfile = '/profile';
const _clientEditProfile = '$_clientProfile/edit';
const _clientAddAuto = '$_clientProfile/add-auto';
const _clientEditAutoForm = '$_clientProfile/form';
const _clientAutoCard = '$_clientProfile/auto-card';

abstract class AppRoutes {
  static String get splash => _splash;
  static String get auth => _auth;
  static String get login => _login;
  static String get forgotEnterPhone => _forgotEnterPhone;
  // static String get forgotVerify => _forgotVerify;
  // static String get forgotSetPass => _forgotSetPass;
  // static String get forgotSuccess => _forgotSuccess;
  static String get registerVerify => _registerVerify;
  static String get registerChoose => _registerChoose;
  static String get registerClientSetPass => _registerClientSetPass;
  static String get registerMasterSetSpec => _registerMasterSetSpec;
  static String get registerMasterSetAutoService =>
      _registerMasterSetAutoService;
  static String get registerMasterSelectCars => _registerMasterSelectCars;
  static String get registerMasterSetAbout => _registerMasterSetAbout;
  static String get registerMasterSetAboutServices =>
      _registerMasterSetAboutServices;
  static String get registerMasterSetAvatar => _registerMasterSetAvatar;

  static String get masterTabbar => _masterTabbar;
  static String get masterOrders => _masterOrders;
  static String get masterChat => _masterChat;
  static String get masterProfile => _masterProfile;
  static String get masterUserProfile => _masterUserProfile;
  static String get masterEditProfile => _masterEditProfile;
  static String get masterEditSpec => _masterEditSpec;
  static String get masterEditAutoService => _masterEditAutoService;
  static String get masterEditCars => _masterEditCars;
  static String get masterEditAvatar => _masterEditAvatar;
  static String get masterEditWorkAvatar => _masterEditWorkAvatar;
  static String get masterEditAbout => _masterEditAbout;
  static String get masterEditAboutService => _masterEditAboutService;

  static String get selectSubcategory => _selectSubcategory;

  // Client
  static String get clientTabbar => _clientTabbar;
  static String get home => _home;
  static String get selectCategory => _selectCategory;
  static String get selectAuto => _selectAuto;
  static String get createRequest => _createRequest;
  static String get selectDate => _selectDate;
  static String get selectTime => _selectTime;
  static String get selectKM => _selectKM;
  static String get allAuto => _allAuto;
  static String get accessories => _accessories;
  static String get accessoriesDetail => _accessoriesDetail;
  static String get allServices => _allServices;
  static String get clientOrders => _clientOrders;
  static String get clientPayOrder => _clientPayOrder;
  static String get clientAllOrders => _clientAllOrders;
  static String get clientOrderDetail => _clientOrderDetail;
  static String get clientOrderMap => _clientOrderMap;
  static String get clientReviewOrder => _clientReviewOrder;
  static String get clientReviewOrderNow => _clientReviewOrderNow;
  static String get clientProfile => _clientProfile;
  static String get clientEditProfile => _clientEditProfile;
  static String get clientAddAuto => _clientAddAuto;
  static String get clientEditAutoForm => _clientEditAutoForm;
  static String get clientAutoCard => _clientAutoCard;
  static String get clientHistoryOrders => _clientHistoryOrders;
}

final loggedOutMap = routemaster.RouteMap(
  onUnknownRoute: (_) => const routemaster.Redirect(_splash),
  routes: {
    _splash: (_) => const TransitionPage(
          child: SplashScreen(),
        ),
    _auth: (_) => TransitionPage(
          child: const AuthScreen(),
        ),

    _registerVerify: (_) => TransitionPage(
          child: AuthCodeVerifyScreen(),
        ),
    _registerChoose: (_) => TransitionPage(
          child: AuthTypeChooseSceen(),
        ),

    _registerClientSetPass: (_) => TransitionPage(
          child: AuthCreatePasswordScreen(),
        ),

    _registerMasterSetSpec: (_) => TransitionPage(
          child: AuthTypeMaster(),
        ),

    AuthAvtoService.routeName: (_) => TransitionPage(
          child: AuthAvtoService(),
        ),

    // _registerMasterSetAutoService: (_) => const TransitionPage(
    //       child: AuthAvtoService(),
    //     ),
    _registerMasterSelectCars: (_) => TransitionPage(
          child: AuthTypeCar(),
        ),

    _registerMasterSetAbout: (_) => TransitionPage(
          child: AuthMore(),
        ),

    _registerMasterSetAboutServices: (_) => TransitionPage(
          child: AuthServiceDescription(),
        ),

    _registerMasterSetAvatar: (_) => TransitionPage(
          child: AuthProfileEditScreen(),
        ),

    _login: (_) => const TransitionPage(
          child: AuthLoginScreen(),
        ),
    _forgotEnterPhone: (_) => const TransitionPage(
          child: AuthForgotEnterPhone(),
        ),
    // _forgotVerify: (_) => const TransitionPage(
    //       child: AuthPasswordRecovery(),
    //     ),
    // _forgotSetPass: (_) => const TransitionPage(
    //       child: AuthNewPasswordScreen(),
    //     ),
    CameraExampleHome.routeName: (route) => TransitionPage(
          child: CameraExampleHome(),
        ),
    CapturePreviewPage.routeName: (route) => TransitionPage(
          child: CapturePreviewPage(),
        ),
    // _forgotSuccess: (_) => const TransitionPage(
    //       child: AuthForgotSuccessScreen(),
    //     ),
  },
);

final loggedInMasterMap = routemaster.RouteMap(
  onUnknownRoute: (_) => const routemaster.Redirect(_masterTabbar),
  routes: {
    _masterTabbar: (_) => routemaster.TabPage(
          paths: const [_masterOrders, _masterChat, _masterProfile],
          child: const MasterTabbarScreen(),
        ),
    _masterOrders: (_) => const TransitionPage(
          child: HomeMasterScreen(),
        ),
    _masterChat: (_) => const TransitionPage(
          child: ChatScreen(),
        ),
    _masterProfile: (_) => const TransitionPage(
          child: ProfileMasterScreen(),
        ),
    _masterUserProfile: (_) => const TransitionPage(
          child: ProfileMasterScreen(),
        ),
    // _masterEditProfile: (_) => const TransitionPage(
    //       child: AuthTypeMaster(),
    //     ),

    // _masterEditAutoService: (_) => const TransitionPage(
    //       child: AuthAvtoService(),
    //     ),
    _masterEditCars: (_) => const TransitionPage(
          child: AuthTypeCar(),
        ),
    _masterEditAvatar: (_) => const TransitionPage(
          child: AuthProfileEditScreen(),
        ),
    _masterEditWorkAvatar: (_) => const TransitionPage(
          child: AuthProfileEditScreen(),
        ),
    _masterEditAbout: (_) => const TransitionPage(
          child: AuthMore(),
        ),
    _masterEditAboutService: (_) => const TransitionPage(
          child: AuthServiceDescription(),
        ),
    HeroPhotoViewRouteWrapper.routeName: (_) => const TransitionPage(
          child: HeroPhotoViewRouteWrapper(),
        ),
    ChatScreen.routeName: (final _) => TransitionPage(
          child:
              // ChangeNotifierProvider.value(
              //   value: context.read<MasterProfileState>(),
              // child:
              ChatScreen(),
          // ),
        ),
    CameraExampleHome.routeName: (route) => TransitionPage(
          child: CameraExampleHome(),
        ),
    CapturePreviewPage.routeName: (route) => TransitionPage(
          child: CapturePreviewPage(),
        ),
    VideoPreviewPage.routeName: (route) => TransitionPage(
          child: VideoPreviewPage(),
        ),
    EditMasterProfilePage.routeName: (route) => TransitionPage(
          child: EditMasterProfilePage(),
        ),
  },
);
final loggedInClientMap = routemaster.RouteMap(
  onUnknownRoute: (_) => const routemaster.Redirect(_clientTabbar),
  routes: {
    _clientTabbar: (_) => routemaster.TabPage(
          paths: const [_home, _clientOrders, _clientProfile],
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => HomeState(context),
                lazy: false,
              ),
              ChangeNotifierProvider(
                create: (context) => CustomerProfileState(context),
                lazy: false,
              ),
            ],
            child: const TabbarScreen(),
          ),
        ),
    _home: (_) => const TransitionPage(
          child: HomeScreen(),
        ),
    _selectSubcategory: (_) => const TransitionPage(
          child: SelectSubService(),
        ),
    _selectCategory: (_) => const TransitionPage(
          child: CategorySelectionPage(),
        ),
    _selectAuto: (_) => const TransitionPage(
          child: AllYourAvtoPage(),
        ),
    _createRequest: (_) => const TransitionPage(
          child: CreateOrderPage(),
        ),
    _selectDate: (_) => const TransitionPage(
          child: OrderDatePage(),
        ),
    // _selectTime: (_) => const TransitionPage(
    //       child: OrderTimePage(),
    //     ),
    _clientOrders: (_) => const TransitionPage(
          child: OrderScreen(),
        ),
    _clientProfile: (_) => const TransitionPage(
          child: ProfileScreen(),
        ),
    _clientEditProfile: (_) => const TransitionPage(
          child: ProfileEditPage(),
        ),
    _clientAddAuto: (_) => const TransitionPage(
          child: AddAutoFirst(),
        ),
    // _clientEditAutoForm: (_) => const TransitionPage(
    //       child: AddAvtoFormPage(),
    //     ),
    _selectKM: (_) => const TransitionPage(
          child: SelectDistancePage(),
        ),
    // _clientAllOrders: (_) => const TransitionPage(
    //       child: YourRequestPage(),
    //     ),
    // _clientOrderDetail: (_) => const TransitionPage(
    //       child: RequestDetailPage(),
    //     ),
    // _clientReviewOrder: (_) => const TransitionPage(
    //       child: ReviewMasterPage(),
    //     ),
    // _clientReviewOrderNow: (_) => const TransitionPage(
    //       child: ReviewNowMasterPage(),
    //     ),
    _allServices: (_) => const TransitionPage(
          child: AllServicesPage(),
        ),
    // _clientPayOrder: (_) => const TransitionPage(
    //       child: PaymentPage(),
    //     ),
    _allAuto: (_) => const TransitionPage(
          child: AllAutoPage(),
        ),
    _accessories: (_) => const TransitionPage(
          child: AccessoriesPage(),
        ),
    // _accessoriesDetail: (_) => const TransitionPage(
    //       child: AccessoriesDetailPage(),
    //     ),
    // _clientOrderMap: (_) => const TransitionPage(
    //       child: MapScreen(),
    //     ),
    _clientHistoryOrders: (_) => const TransitionPage(
          child: AllHistoryOrdersPage(),
        ),
    CameraExampleHome.routeName: (route) => TransitionPage(
          child: CameraExampleHome(),
        ),
    CapturePreviewPage.routeName: (route) => TransitionPage(
          child: CapturePreviewPage(),
        ),
    AuthContactsScreen.routeNameFull: (route) => TransitionPage(
          child: AuthContactsScreen(
              isAuth:
                  route.pathParameters[AuthContactsScreen.authParam] == 'true'),
        ),
    AccessoriesPage.routeName: (route) => TransitionPage(
          child: const AccessoriesPage(),
        ),
    ReviewMasterPage.routeName: (route) => TransitionPage(
          child: ReviewMasterPage(),
        ),
    ReviewNowMasterPage.routeName: (route) => TransitionPage(
          child: ReviewNowMasterPage(
            masterAvatar: reviewMasterUIData!.masterAvatar,
            masterName: reviewMasterUIData!.masterName,
            masterId: reviewMasterUIData!.masterId,
            address: reviewMasterUIData!.address,
            phone: reviewMasterUIData!.phone,
            orderId: reviewMasterUIData!.orderId,
          ),
        ),
    WebViewPayment.routeName: (route) => TransitionPage(
          child: WebViewPayment(params: webViewParams!),
        ),
  },
);

import 'package:get/get.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_additional_task_screen/employee_additional_screen.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_home_screen/employee_home_screen.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_notification_screen/employee_notification_screen.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_profile_screen/employee_edit_profile/employee_edit_profile.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_profile_screen/employee_profile_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/authentication/forget_password_screen/forgot_password_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/authentication/forgot_password_otp/forgot_password_otp.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/authentication/free_service_screen/free_service_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/authentication/free_service_screen/free_sevice_new_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/authentication/reset_password_screen/reset_password_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/authentication/sign_in_screen/sign_in_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/authentication/sign_up_otp/sign_up_otp.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/authentication/sign_up_screen/sign_up_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/add_employee_screen/add_employee_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/add_employee_screen/mail_sent_successfully_screen/main_sent_successfully_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/all_employee_show/all_employee_show.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/employee_details/edit_employee_details/edit_employee_details.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/employee_details/employee_details.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/home_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/house_information_screen/house_information_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/house_type_screen/house_type_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/room_details_screen/room_details_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/language_screen/language_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/my_plan_screen/my_plan_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/personal_info_screen/edit_profile_screen/edit_profile_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/personal_info_screen/personal_info_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/setting_screen/change_password_screen/change_password_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/setting_screen/faq/faq_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/setting_screen/help_where_screen/help_where_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/setting_screen/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/setting_screen/setting_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/setting_screen/terms_and_service_screen/terms_and_service_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/upgrade_packages/upgrade_packages.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/owner_nav/owner_nav_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/recipe_screen/add_recipe_screen/add_new_recipe/add_new_recipe.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/recipe_screen/add_recipe_screen/add_recipe_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/recipe_screen/favorite_recipes_screen/favorites_recipe_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/recipe_screen/my_recipe_screen/my_recipe_details/my_recipe_details.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/recipe_screen/my_recipe_screen/my_recipe_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/recipe_screen/tags_screen/my_single_tags.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/recipe_screen/tags_screen/tags_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/task_schedule/all_task_screen/all_task_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/task_schedule/completed_task/completed_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/task_schedule/create_task/create_task.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/task_schedule/grocery_task/add_grocery_task/add_grocery_task.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/task_schedule/grocery_task/grocery_task.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/task_schedule/ongoing_task/ongoing_task.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/task_schedule/pending_task/pending_task.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/splash_screen/splash_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/wallet_screen/add_expense_screen/add_expense_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/wallet_screen/budget_details_screen/budget_details_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/wallet_screen/crerate_budget_screen/create_budget_screen.dart';
import 'package:tidybayte/app/view/screens/onboard_screen/chose_onboard_screen/chose_onboard_screen.dart';
import 'package:tidybayte/app/view/screens/onboard_screen/get_started_screen/get-started_screen.dart';
import 'package:tidybayte/app/view/screens/onboard_screen/get_started_screen/get_started_loading.dart';

import 'package:tidybayte/app/view/screens/onboard_screen/home_owner_chose_auth/home_owner_chose_auth.dart';
import 'package:tidybayte/app/view/screens/onboard_screen/language_onboarding/language_onboarding_screen.dart';
import 'package:tidybayte/app/view/screens/onboard_screen/subscription_main/subscription_main_screen.dart';
import 'package:tidybayte/app/view/screens/onboard_screen/welcome/welcome_screen.dart';

import '../../view/screens/home_owner_screen/recipe_screen/my_recipe_screen/my_recipe_details/pdf_viewer_screen.dart';
import '../../view/screens/home_owner_screen/recipe_screen/my_recipe_screen/my_recipe_details/web_view_screen.dart';

class AppRoutes {
  static const String splashScreen = "/SplashScreen";
  static const String signInScreen = "/SignInScreen";
  static const String employeeNotificationScreen =
      "/EmployeeNotificationScreen";
  static const String welcomeScreen = "/WelcomeScreen";
  static const String choseOnBoardingScreen = "/ChoseOnBoardingScreen";
  static const String homeOwnerChoseAuth = "/HomeOwnerChoseAuth";
  static const String signUpScreen = "/SignUpScreen";
  static const String signUpOtp = "/SignUpOtp";
  static const String forgotPasswordScreen = "/ForgotPasswordScreen";
  static const String forgotPasswordOtp = "/ForgotPasswordOtp";
  static const String resetPasswordScreen = "/ResetPasswordScreen";
  static const String freeServiceScreen = "/FreeServiceScreen";

  ///=================================Home Section=================
  static const String homeScreen = "/HomeScreen";
  static const String ownerNavScreen = "/OwnerNavScreen";
  static const String houseTypeScreen = "/HouseTypeScreen";
  static const String houseInformationScreen = "/HouseInformationScreen";
  static const String allEmployeeShow = "/AllEmployeeShow";
  static const String employeeDetails = "/EmployeeDetails";
  static const String addEmployeeScreen = "/AddEmployeeScreen";
  static const String roomDetailsScreen = "/RoomDetailsScreen";
  static const String editEmployeeDetails = "/EditEmployeeDetails";
  static const String mainSentSuccessfullyScreen =
      "/MainSentSuccessfullyScreen";

  ///===================Wallet Section===================
  static const String createBudgetScreen = "/CreateBudgetScreen";
  static const String budgetDetailsScreen = "/BudgetDetailsScreen";
  static const String addExpenseScreen = "/AddExpenseScreen";

  ///====================Recipe section===================
  static const String addRecipeScreen = "/AddRecipeScreen";
  static const String myRecipeScreen = "/MyRecipeScreen";
  static const String favoritesRecipeScreen = "/FavoritesRecipeScreen";
  static const String tagsScreen = "/TagsScreen";
  static const String addNewRecipe = "/AddNewRecipe";
  static const String myRecipeDetails = "/MyRecipeDetails";
  static const String mySingleTags = "/MySingleTags";
  static const String webViewScreen = "/webViewScreen";
  static const String pdfViewerScreen = "/pdfViewerScreen";

  ///===================Schedule Screen====================
  static const String allTaskScreen = "/AllTaskScreen";
  static const String completedScreen = "/CompletedScreen";
  static const String ongoingTask = "/OngoingTask";
  static const String pendingTask = "/PendingTask";
  static const String groceryTask = "/GroceryTask";
  static const String addGroceryTask = "/AddGroceryTask";

  ///================================Menu Screen =====================
  static const String personalInfoScreen = "/PersonalInfoScreen";
  static const String upgradePackages = "/UpgradePackages";
  static const String myPlanScreen = "/MyPlanScreen";
  static const String settingScreen = "/SettingScreen";
  static const String changePasswordScreen = "/ChangePasswordScreen";
  static const String termsAndServiceScreen = "/TermsAndServiceScreen";
  static const String privacyPolicyScreen = "/PrivacyPolicyScreen";
  static const String helpWhereScreen = "/HelpWhereScreen";
  static const String editProfileScreen = "/EditProfileScreen";
  static const String faqScreen = "/FaqScreen";

  ///====================Employee section===================
  static const String employeeEditProfile = "/EmployeeEditProfile";
  static const String employeeProfileScreen = "/EmployeeProfileScreen";
  static const String employeeHomeScreen = "/EmployeeHomeScreen";
  static const String employeeAdditionalScreen = "/EmployeeAdditionalScreen";
  static const String createTask = "/CreateTask";
  static const String languageScreen = "/LanguageScreen";
  static const String getStartedScreen = "/GetStartedScreen";
  static const String getStartedLoadingScreen = "/GetStartedLoadingScreen";
 // static const String languageOnboardingScreen = "/LanguageOnboardingScreen";
  static const String subscriptionOnboardingScreen = "/SubscriptionOnboardingScreen";
static const String freeServiceNewScreen ="/FreeServiceNewScreen";
  ///====================GetPage===================
  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: signInScreen,
      page: () => SignInScreen(),
      // customTransition: FadeSlideTransition()
    ),
    GetPage(
      name: welcomeScreen,
      page: () => const WelcomeScreen(),
      // customTransition: SlideBlurTransition()
    ),
    GetPage(
      name: choseOnBoardingScreen,
      page: () => const ChoseOnboardScreen(),
      // customTransition: SlideBlurTransition()
    ),
    GetPage(
      name: homeOwnerChoseAuth,
      page: () => HomeOwnerChoseAuth(),
      // customTransition: SlideBlurTransition()
    ),
    GetPage(
      name: signUpScreen,
      page: () => SignUpScreen(),
      // customTransition: FadeSlideTransition()
    ),
    GetPage(
      name: signUpOtp,
      page: () => const SignUpOtp(),
      // customTransition: FadeSlideTransition()
    ),
    GetPage(
      name: forgotPasswordScreen,
      page: () => ForgotPasswordScreen(),
      // customTransition: FadeSlideTransition()
    ),
    GetPage(
      name: forgotPasswordOtp,
      page: () => ForgotPasswordOtp(),
      // customTransition: FadeSlideTransition()
    ),
    GetPage(
      name: resetPasswordScreen,
      page: () => ResetPasswordScreen(),
      // customTransition: FadeSlideTransition()
    ),
    GetPage(
      name: freeServiceScreen,
      page: () => FreeServiceScreen(),
      // customTransition: FadeSlideTransition()
    ),

    ///===========================Home Section=======================
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: ownerNavScreen, page: () => const OwnerNavScreen()),
    GetPage(name: houseTypeScreen, page: () => const HouseTypeScreen()),
    GetPage(name: houseInformationScreen, page: () => HouseInformationScreen()),
    GetPage(
      name: allEmployeeShow,
      page: () => AllEmployeeShow(),
      // customTransition: SlideBlurTransition()
    ),
    GetPage(
      name: employeeDetails,
      page: () => const EmployeeDetails(),
      // customTransition: SlideScaleTransition()
    ),
    GetPage(name: addEmployeeScreen, page: () => const AddEmployeeScreen()),
    GetPage(name: roomDetailsScreen, page: () => const RoomDetailsScreen()),
    GetPage(
      name: mainSentSuccessfullyScreen,
      page: () => const MainSentSuccessfullyScreen(),
      // customTransition: RotateScaleTransition()
    ),

    ///=========================Wallet section==============
    GetPage(name: createBudgetScreen, page: () => CreateBudgetScreen()),
    GetPage(
      name: budgetDetailsScreen,
      page: () => const BudgetDetailsScreen(),
      // customTransition: SlideScaleTransition()
    ),
    GetPage(name: addExpenseScreen, page: () => AddExpenseScreen()),

    ///======================Recipe Section====================
    GetPage(
      name: addRecipeScreen,
      page: () => const AddRecipeScreen(),
    ),
    GetPage(
      name: myRecipeScreen,
      page: () => MyRecipeScreen(),
      // customTransition: SlideBlurTransition()
    ),
    GetPage(
      name: favoritesRecipeScreen,
      page: () => FavoritesRecipeScreen(),
      // customTransition: RotateScaleTransition()
    ),
    GetPage(
      name: tagsScreen,
      page: () => TagsScreen(),
      // customTransition: SlideScaleTransition()
    ),
    GetPage(
      name: addNewRecipe,
      page: () => const AddNewRecipe(),
      // customTransition: SlideBlurTransition()
    ),
    GetPage(
      name: myRecipeDetails,
      page: () => const MyRecipeDetails(),
      // customTransition: SlideScaleTransition()
    ),
    GetPage(name: mySingleTags,
        page: () => const MySingleTags(),
    ),
    GetPage(
      name: webViewScreen,
      page: () => const WebViewScreen(),
    ),
    GetPage(
      name: pdfViewerScreen,
      page: () => const PdfViewerScreen(),
    ),

    ///===========================Schedule Screen=====================
    GetPage(
      name: allTaskScreen,
      page: () => AllTaskScreen(),
      // customTransition: SlideBlurTransition()
    ),
    GetPage(
      name: completedScreen,
      page: () => const CompletedScreen(),
      // customTransition: SlideBlurTransition()
    ),
    GetPage(
      name: ongoingTask,
      page: () => const OngoingTask(),
      // customTransition: SlideBlurTransition()
    ),
    GetPage(
      name: pendingTask,
      page: () => const PendingTask(),
      // customTransition: SlideBlurTransition()
    ),
    GetPage(
      name: groceryTask,
      page: () => const GroceryTask(),
      // customTransition: SlideBlurTransition()
    ),
    GetPage(
      name: addGroceryTask,
      page: () => const AddGroceryTask(),
      // customTransition: SlideBlurTransition()
    ),

    ///================================Menu Screen =====================
    GetPage(
      name: personalInfoScreen,
      page: () => PersonalInfoScreen(),
      // customTransition: ScaleTransitionEffect(),
    ),
    GetPage(
      name: upgradePackages,
      page: () => UpgradePackages(),
      // customTransition: ScaleTransitionEffect(),
    ),
    GetPage(
      name: myPlanScreen,
      page: () => MyPlanScreen(),
      // customTransition: ScaleTransitionEffect(),
    ),
    GetPage(
      name: settingScreen,
      page: () => const SettingScreen(),
      // customTransition: ScaleTransitionEffect(),
    ),
    GetPage(
      name: changePasswordScreen,
      page: () => ChangePasswordScreen(),
      // customTransition: ScaleTransitionEffect(),
    ),
    GetPage(
      name: termsAndServiceScreen,
      page: () => const TermsAndServiceScreen(),
      // customTransition: ScaleTransitionEffect(),
    ),
    GetPage(
      name: privacyPolicyScreen,
      page: () => const PrivacyPolicyScreen(),
      // customTransition: ScaleTransitionEffect(),
    ),
    GetPage(
      name: helpWhereScreen,
      page: () => const HelpWhereScreen(),
      // customTransition: ScaleTransitionEffect(),
    ),
    GetPage(
      name: editProfileScreen,
      page: () => const EditProfileScreen(),
      transition: Transition.fadeIn,
      // ✅ Default transition
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: createTask,
      page: () => CreateTask(),
      // customTransition: SlideScaleTransition()
    ),
    GetPage(
      name: faqScreen,
      page: () => const FaqScreen(),
      // customTransition: ScaleTransitionEffect(),
    ),

    ///======================Employee section=========================
    GetPage(name: employeeEditProfile, page: () => const EmployeeEditProfile()),
    GetPage(name: employeeProfileScreen, page: () => EmployeeProfileScreen()),
    GetPage(name: employeeHomeScreen, page: () => const EmployeeHomeScreen()),
    GetPage(name: employeeNotificationScreen,page: () => EmployeeNotificationScreen(),
      transition: Transition.fadeIn,
      // transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
        name: employeeAdditionalScreen,
        page: () => const EmployeeAdditionalScreen()),
    GetPage(name: editEmployeeDetails, page: () => const EditEmployeeDetails()),
    GetPage(name: languageScreen, page: () => LanguageScreen()),
    GetPage(name: getStartedScreen, page: () => const GetStartedScreen()),
    GetPage(name: getStartedLoadingScreen, page: () => const GetStartedLoadingScreen()),
  //  GetPage(name: languageOnboardingScreen, page: () =>  LanguageOnBoardingScreen()),

  GetPage(
  name: subscriptionOnboardingScreen,
  page: () => SubscriptionMainScreen(
  isOnboarding: Get.arguments?['isOnboarding'] ?? false,
  isFreeEnd: Get.arguments?['isFreeEnd'] ?? false,
  ),
  ),

    GetPage(name: freeServiceNewScreen, page: () =>  FreeServiceNewScreen()),


  ];
}

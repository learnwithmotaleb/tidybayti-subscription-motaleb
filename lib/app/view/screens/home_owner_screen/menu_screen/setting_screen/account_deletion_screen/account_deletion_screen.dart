import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';

/// Real in-app account deletion (Apple Guideline 5.1.1(v)).
///
/// Apps outside highly-regulated industries are not allowed to route
/// deletion through customer-service channels (email/phone) — the app must
/// delete the account directly. Tapping the button below opens a
/// confirmation dialog asking for the account's email + password, then
/// calls the delete-account API and signs the user out on success.
class AccountDeletionScreen extends StatelessWidget {
  const AccountDeletionScreen({super.key});

  Future<void> _openDeleteDialog(BuildContext context) async {
    await Get.dialog(
      const _DeleteAccountDialog(),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.addedColor,
        body: SafeArea(
          child: Padding(
            padding: ResponsiveHelper.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomMenuAppbar(
                  title: AppStrings.accountDeletionTitle.tr,
                  onBack: Get.back,
                ),
                SizedBox(height: ResponsiveHelper.spacing(20)),
                Text(
                  AppStrings.deleteAccountDescription.tr,
                  style: TextStyle(
                    color: AppColors.dark300,
                    fontSize: ResponsiveHelper.fontSize(18),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(24)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ResponsiveHelper.spacing(16)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(16),
                    ),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This will permanently delete your account',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: ResponsiveHelper.fontSize(18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(8)),
                      Text(
                        'All of your data — households, tasks, recipes and '
                        'budgets — will be removed and this cannot be undone.',
                        style: TextStyle(
                          color: AppColors.dark400,
                          fontSize: ResponsiveHelper.fontSize(16),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CustomButton(
                  onTap: () => _openDeleteDialog(context),
                  fillColor: AppColors.buttonRed,
                  title: AppStrings.requestAccountDeletion.tr,
                  textColor: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(18),
                  radius: ResponsiveHelper.borderRadius(16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndDelete() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final response = await _apiClient.delete(
        url: ApiUrl.deleteAccount,
        // isBasic: false (default) => ApiClient sends bearerHeaderInfo(),
        // i.e. Authorization: Bearer <saved token>, alongside the
        // email/password body the backend uses to confirm identity.
        isBasic: false,
        body: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        await _clearLocalSession();

        if (!mounted) return;
        Get.back(); // close dialog

        Get.snackbar(
          'Account deleted',
          'Your account has been permanently deleted.',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(AppRoutes.choseOnBoardingScreen);
        return;
      }

      final message = response.body is Map
          ? (response.body['message']?.toString() ??
              'Unable to delete account. Please check your email and password.')
          : 'Unable to delete account. Please check your email and password.';

      setState(() {
        _isLoading = false;
        _errorText = message;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = 'Something went wrong. Please try again.';
      });
    }
  }

  Future<void> _clearLocalSession() async {
    await SharePrefsHelper.remove(AppConstants.token);
    await SharePrefsHelper.remove(AppConstants.profileID);
    await SharePrefsHelper.setBool(SharedPreferenceValue.isSubscribed, false);
    await SharePrefsHelper.setString(
        SharedPreferenceValue.activeProductId, '');
    await SharePrefsHelper.setBool(AppConstants.rememberMe, false);
    await SharePrefsHelper.setBool(AppConstants.isOwner, false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
      ),
      child: Padding(
        padding: ResponsiveHelper.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm account deletion',
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveHelper.fontSize(20),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(6)),
              Text(
                'Enter your email and password to permanently delete your '
                'account. This action cannot be undone.',
                style: TextStyle(
                  color: AppColors.dark400,
                  fontSize: ResponsiveHelper.fontSize(14),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(16)),
              CustomTextField(
                textEditingController: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email',
                fieldBorderRadius: ResponsiveHelper.borderRadius(8),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(value.trim())) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: ResponsiveHelper.spacing(12)),
              CustomTextField(
                textEditingController: _passwordController,
                isPassword: true,
                hintText: 'Password',
                fieldBorderRadius: ResponsiveHelper.borderRadius(8),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              if (_errorText != null) ...[
                SizedBox(height: ResponsiveHelper.spacing(10)),
                Text(
                  _errorText!,
                  style: TextStyle(
                    color: AppColors.buttonRed,
                    fontSize: ResponsiveHelper.fontSize(13),
                  ),
                ),
              ],
              SizedBox(height: ResponsiveHelper.spacing(20)),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: _isLoading ? () {} : () => Get.back(),
                      fillColor: Colors.grey.shade200,
                      title: 'Cancel',
                      textColor: AppColors.black,
                      height: ResponsiveHelper.buttonHeight(48),
                      radius: ResponsiveHelper.borderRadius(12),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(12)),
                  Expanded(
                    child: CustomButton(
                      onTap: _isLoading ? () {} : _confirmAndDelete,
                      fillColor: AppColors.buttonRed,
                      title: _isLoading ? 'Deleting...' : 'Delete',
                      textColor: Colors.white,
                      height: ResponsiveHelper.buttonHeight(48),
                      radius: ResponsiveHelper.borderRadius(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

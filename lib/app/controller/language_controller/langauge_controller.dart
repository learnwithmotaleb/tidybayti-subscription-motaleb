import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  RxBool isLanguage = false.obs;
  RxInt selectedCategory = 0.obs;
  TextEditingController language = TextEditingController();
  Locale? _locale;
  Locale get locale => _locale ?? const Locale("en", "US");

  @override
  void onInit() {
    super.onInit();
    loadLocal();
  }

  Future<void> loadLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language_code');

    String? countryCode = prefs.getString('country_code');
    if (langCode != null) {
      _locale = Locale(langCode, countryCode);
      Get.updateLocale(_locale!);

      if (langCode == "en") {
        selectedCategory.value = 0;
        language.text = 'English';
      } else if (langCode == 'ar') {
        selectedCategory.value = 1;
        language.text = 'العربية';
      } else {
        _locale = const Locale("en", "US");
        language.text = 'English';
      }
    }
  }

  Future<void> changeLocale(Locale newLocale) async {
    _locale = newLocale;
    Get.updateLocale(_locale!);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLocale.languageCode);
    await prefs.setString('country_code', newLocale.countryCode!);

    if (newLocale.languageCode == "en") {
      selectedCategory.value = 0;
      language.text = 'English';
    } else if (newLocale.languageCode == 'ar') {
      selectedCategory.value = 1;
      language.text = 'العربية';
    }
    isLanguage.value = false;
  }
}

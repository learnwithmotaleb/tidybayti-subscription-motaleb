import 'package:get/get.dart';
import 'package:tidybayte/app/global/language/arabic.dart';
import 'package:tidybayte/app/global/language/english.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "en_US": english,
    "ar_SA": arabic,
  };
}

import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/model/owner_model/manage/faq_model.dart';
import 'package:tidybayte/app/data/model/owner_model/manage/terms_model.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

class InfoController extends GetxController {
  ApiClient apiClient = serviceLocator();

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final rxRequestStatus = Status.loading.obs;

  ///==================================✅✅infoData✅✅=======================

  bool isApi = false;
  Rx<TermsData> termsData = TermsData().obs;

  Future<void> infoData() async {
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      String url = isApi ? ApiUrl.terms : ApiUrl.privacy;
      final response = await apiClient.get(url: url, showResult: true);

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body["data"];

        if (responseData != null) {
          termsData.value = TermsData.fromJson(responseData);
          print('✅ Success: Status Code = ${response.statusCode}');
          print('📄 Description: ${termsData.value.description}');
          setRxRequestStatus(Status.completed);
        } else {
          print("⚠️ Warning: Response data is null");
          setRxRequestStatus(Status.error);
        }
      } else {
        print("❌ Error: Unexpected Status Code = ${response.statusCode}");
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("❗ Exception: $e");
      setRxRequestStatus(Status.error);
    } finally {
      refresh();
    }
  }

  ///==================================✅✅Faq✅✅=======================
  // Track the selected FAQ item index
  var selectedIndex = Rx<int?>(null);

// Toggle the selected FAQ item
  void toggleItem(int index) {
    selectedIndex.value = selectedIndex.value == index ? null : index;
  }

  Rx<FaqModel> faqList = FaqModel().obs;

  Future<void> getFaq() async {
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      final response = await apiClient.get(url: ApiUrl.getFaq, showResult: true);

      if (response.statusCode == 200 && response.body != null) {
        faqList.value = FaqModel.fromJson(response.body); // ✅ Correctly parsing response

        print('✅ Success: Status Code = ${response.statusCode}');
        print('📄 Total FAQs: ${faqList.value.data?.length ?? 0}');

        setRxRequestStatus(Status.completed);
      } else {
        print("❌ Error: Unexpected Status Code = ${response.statusCode}");
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("❗ Exception: $e");
      setRxRequestStatus(Status.error);
    } finally {
      refresh();
    }
  }

@override
void onInit() {
  getFaq();
  super.onInit();
}
}

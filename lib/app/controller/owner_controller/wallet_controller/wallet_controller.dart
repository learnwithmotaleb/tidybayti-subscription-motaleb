import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/model/owner_model/budget_category.dart';
import 'package:tidybayte/app/data/model/owner_model/budget_details.dart';
import 'package:tidybayte/app/data/model/owner_model/budget_model.dart';
import 'package:tidybayte/app/data/model/owner_model/over_view_model.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

class WalletController extends GetxController {
  ApiClient apiClient = serviceLocator();

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final rxRequestStatus = Status.loading.obs;

  RxString selectedCurrency = 'BHD'.obs;
  RxBool isSelected = false.obs;
  RxBool isCustomCategory = false.obs;
  /// ================= DEFAULT IMAGE FOR OTHER =================
  final String defaultOtherImage =
      "https://res.cloudinary.com/dkfvvufsa/image/upload/v1780554460/budget_grupto.png";

  clearField() {
    categoryNameController.clear();
    customCategoryController.clear(); // ✅ added
    dateController.clear();
    amountController.clear();
    imageController.clear();
    isCustomCategory.value = false;
    isSelected.value = false;
  }

  clearExpenseField() {
    expenseDateController.clear();
    expenseAmountController.clear();
  }

  final dateController = TextEditingController();
  final amountController = TextEditingController();
  final categoryNameController = TextEditingController();
  final customCategoryController = TextEditingController();
  final imageController = TextEditingController();
  final expenseDateController = TextEditingController();
  final expenseAmountController = TextEditingController();
  final newFieldController=TextEditingController();
  RxBool isCreateLoading = false.obs;
  RxBool isExpenseLoading = false.obs;

  ///==================================✅✅Budget Create✅✅=======================

  budgetCreate() async {
    isCreateLoading.value = true;

    /// 🧠 decide final category
    final String finalCategory = isCustomCategory.value
        ? customCategoryController.text.trim()
        : categoryNameController.text.trim();

    final String finalImage = isCustomCategory.value
        ? defaultOtherImage
        : imageController.text;

    var body = {
    //  "category": categoryNameController.text,
       "category": finalCategory,
      //"budgetImage": imageController.text,
      "budgetImage":finalImage ,
      "budgetDateStr": dateController.text,
      // "currency": currencyController.text,
      "amount": int.parse(amountController.text)
    };

    var response = await apiClient.post(body: body, url: ApiUrl.budgetCreate);
    if (response.statusCode == 201) {
      getBudget();
      clearField();
      toastMessage(message: response.body["message"]);
      Get.back();
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isCreateLoading.value = false;
    isCreateLoading.refresh();
  }






  bool validateBudgetForm() {
    final String category = isCustomCategory.value
        ? customCategoryController.text.trim()
        : categoryNameController.text.trim();

    if (category.isEmpty) {
      toastMessage(message: "Please select or enter category");
      return false;
    }

    if (dateController.text.trim().isEmpty) {
      toastMessage(message: "Please select date");
      return false;
    }

    final amountText = amountController.text.trim();

    if (amountText.isEmpty) {
      toastMessage(message: "Please enter amount");
      return false;
    }

    final amount = int.tryParse(amountText);

    if (amount == null || amount <= 0) {
      toastMessage(message: "Enter valid amount");
      return false;
    }

    return true;
  }






  ///==================================✅✅Expense ✅✅=======================

  expenseAdd({required String budgetId}) async {
    isExpenseLoading.value = true;
    var body = {
      "budgetId": budgetId,
      "expenseDateStr": expenseDateController.text,
      "amount": int.parse(expenseAmountController.text)
    };

    var response = await apiClient.post(body: body, url: ApiUrl.expenseCreate);
    if (response.statusCode == 201) {
      clearExpenseField();
      getSingleBudget(budgetId: budgetId);
      toastMessage(message: response.body["message"]);
      Get.back();
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isExpenseLoading.value = false;
    isExpenseLoading.refresh();
  }

  ///==================================✅✅getCategoryBudget✅✅=======================


  TextEditingController manualCategoryController = TextEditingController();
  RxBool isManualMode = false.obs;

  RxList<CategoryList> budgetCategoryList = <CategoryList>[].obs;

  getCategoryBudget() async {
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      final response =
          await apiClient.get(url: ApiUrl.getCategoryBudget, showResult: true);

      if (response.statusCode == 200) {
        budgetCategoryList.value = List<CategoryList>.from(
            response.body["data"].map((x) => CategoryList.fromJson(x)));
        print('StatusCode==================${response.statusCode}');
        print(
            'Total budgetCategoryList ==================${budgetCategoryList.length}');

        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
      print('Error fetching data: $e');
    }
  }

  ///==================================✅✅Budget Get✅✅=======================

  Rx<BudgetData> budgetData = BudgetData().obs;

  getBudget() async {
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      final response =
          await apiClient.get(url: ApiUrl.getMyBudget, showResult: true);

      if (response.statusCode == 200) {
        budgetData.value = BudgetData.fromJson(response.body["data"]);

        print('StatusCode==================${response.statusCode}');
        print(
            'budgetData Result==================${budgetData.value.result?.length}');

        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
      print('Error fetching data: $e');
    }
  }

  ///==================================✅✅Budget Single Get✅✅=======================

  Rx<BudgetDetailsData> budgetDetailsData = BudgetDetailsData().obs;

  getSingleBudget({required String budgetId}) async {
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      final response = await apiClient.get(
          url: ApiUrl.getSingleBudget(budgetId), showResult: true);

      if (response.statusCode == 200) {
        budgetDetailsData.value =
            BudgetDetailsData.fromJson(response.body["data"]);

        print('StatusCode==================${response.statusCode}');
        print(
            'budgetData Single==================${budgetDetailsData.value.expenses?.length}');

        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
      print('Error fetching data: $e');
    }
  }

  ///==================================✅✅Remove Expense✅✅=======================
  RxBool isRemoveExpense = false.obs;

  removeExpense({required String expenseId, required String budgetId}) async {
    isRemoveExpense.value = true;
    var body = {"expenseId": expenseId};

    var response =
        await apiClient.delete(body: body, url: ApiUrl.deleteExpense);
    if (response.statusCode == 200) {
      getSingleBudget(budgetId: budgetId);
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isRemoveExpense.value = false;
    isRemoveExpense.refresh();
  }

  ///==================================✅✅Remove Budget✅✅=======================
  RxBool isRemoveBudget = false.obs;

  removeBudget({required String budgetId}) async {
    isRemoveBudget.value = true;
    var body = {"budgetId": budgetId};

    var response = await apiClient.delete(body: body, url: ApiUrl.deleteBudget);
    if (response.statusCode == 200) {
      getBudget();
      Get.back();
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isRemoveBudget.value = false;
    isRemoveBudget.refresh();
  }

  ///==================================✅✅OverView✅✅=======================

  Rx<OverviewData> overViewData = OverviewData().obs;

  getOverView({required String month, required String year}) async {
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      final response = await apiClient.get(
          url: ApiUrl.overview(month, year), showResult: true);

      if (response.statusCode == 200) {
        overViewData.value = OverviewData.fromJson(response.body["data"]);

        print('StatusCode==================${response.statusCode}');
        print(
            'overViewData Result==================${overViewData.value.result?.length}');

        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
      print('Error fetching data: $e');
    }
  }

  ///==================================✅✅ Edit Budget (PATCH) ✅=================================

  RxBool isBudgetUpdating = false.obs;

  editBudget({
    required String budgetId,
    required String category,
    required String amount,
  }) async {
    isBudgetUpdating.value = true;

    var body = {
      "budgetId": budgetId,
      "category": category,
      "amount": amount,
    };

    try {
      final response = await apiClient.patch(
        url: ApiUrl.updateBudget,
        body: body,
      );

      if (response.statusCode == 200) {



        toastMessage(message: response.body["message"]);

        /// Close edit dialog
        Get.back();

        /// Refresh updated budget
        await getSingleBudget(budgetId: budgetId);

        // /// Close edit dialog
        // Get.back();
      } else if (response.statusCode == 400) {
        toastMessage(message: response.body["message"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      toastMessage(message: "Error: ${e.toString()}");
    }

    isBudgetUpdating.value = false;
    isBudgetUpdating.refresh();
  }

  @override
  void onInit() {
    getBudget();
    getCategoryBudget();
    super.onInit();
  }
}

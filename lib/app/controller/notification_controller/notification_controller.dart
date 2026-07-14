import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/data/model/owner_model/notification/notification.dart';

class NotificationController extends GetxController {
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final rxRequestStatus = Status.loading.obs;
  ApiClient apiClient = serviceLocator();

  RxList<NotificationData> notificationList = <NotificationData>[].obs;

  Future<void> getNotification() async {
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      final response =
          await apiClient.get(url: ApiUrl.notification, showResult: true);

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body["data"];

        if (responseData != null) {
          notificationList.assignAll(
            List<NotificationData>.from(
                responseData.map((x) => NotificationData.fromJson(x))),
          );

          // Convert the createdAt to 'time ago' format
          notificationList.forEach((data) {
            final createdAt = data.createdAt;
            if (createdAt != null) {
              // data.timeAgo = timeAgo(createdAt.toLocal());
            }
          });

          print('✅ Success: Status Code = ${response.statusCode}');
          print('📄 Total notifications = ${notificationList.length}');
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

  @override
  void onInit() {
    getNotification();
    super.onInit();
  }

  // The timeAgo method (as helper function within the controller)
  String timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays >= 365) {
      int years = difference.inDays ~/ 365;
      return '${years} year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 30) {
      int months = difference.inDays ~/ 30;
      return '${months} month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

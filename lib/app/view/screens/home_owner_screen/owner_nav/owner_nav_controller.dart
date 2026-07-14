import 'package:get/get.dart';

class OwnerNavController extends GetxController {
  // Reactive variable to manage current index
  var currentIndex = 0.obs;

  // Function to update the index
  void setIndex(int index) {
    currentIndex.value = index;
  }
}

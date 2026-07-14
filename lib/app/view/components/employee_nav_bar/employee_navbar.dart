import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_additional_task_screen/employee_additional_screen.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_grocery/employee_grocery_screen.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_home_screen/employee_home_screen.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_profile_screen/employee_profile_screen.dart';

class EmployeeNavbar extends StatefulWidget {
  final int currentIndex;

  const EmployeeNavbar({required this.currentIndex, super.key});

  @override
  State<EmployeeNavbar> createState() => _EmployeeNavbarState();
}

class _EmployeeNavbarState extends State<EmployeeNavbar> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      indicatorColor: AppColors.employeeCardColor, // or Colors.green
      backgroundColor: AppColors.blue300,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        onTap(index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_task_outlined),
          selectedIcon: Icon(Icons.add_task),
          label: 'Task List',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: 'Grocery',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  void onTap(int index) {
    if (index != widget.currentIndex) {
      switch (index) {
        case 0:
          Get.offAll(() => const EmployeeHomeScreen());
          break;
        case 1:
          Get.to(() => const EmployeeAdditionalScreen());
          break;
        case 2:
          Get.to(() => const EmployeeGroceryScreen());
          break;
        case 3:
          Get.to(() => EmployeeProfileScreen());
          break;
      }
    }
  }
}
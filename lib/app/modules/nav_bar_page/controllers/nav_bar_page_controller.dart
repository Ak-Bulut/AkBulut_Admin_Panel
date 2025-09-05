import 'package:akbulut_admin/app/data/services/dahua_service.dart';
import 'package:akbulut_admin/app/modules/attendance_view/views/attendance_view.dart';
import 'package:akbulut_admin/app/product/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBarPageController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final DahuaService dahuaService = DahuaService();

  late final List<Widget> pages;

  late final List<String> drawerTitles;
  late final List<IconData> drawerIcons;
  late final List<IconData> drawerSelectedIcons;

  @override
  void onInit() {
    super.onInit();
    _initializeNavigationItems();
  }

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void _initializeNavigationItems() {
    pages = [
      AttendanceView(),
      Container(child: Center(child: Text('Page 2'))),
      Container(child: Center(child: Text('Page 3'))),
      Container(child: Center(child: Text('Page 4'))),
      Container(child: Center(child: Text('Page 5'))),
      Container(child: Center(child: Text('Page 6'))),
      Container(child: Center(child: Text('Page 7'))),
    ];
    drawerTitles = List<String>.from(StringConstants.titles);
    drawerIcons = List<IconData>.from(StringConstants.icons);
    drawerSelectedIcons = List<IconData>.from(StringConstants.selectedIcons);
  }

  void toggleAdmin() {
    _initializeNavigationItems();
    if (selectedIndex.value >= pages.length) {
      selectedIndex.value = 0;
    }
    update();
  }
}

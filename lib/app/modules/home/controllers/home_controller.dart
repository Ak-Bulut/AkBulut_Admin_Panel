import 'package:akbulut_admin/app/data/models/employee.dart';
import 'package:akbulut_admin/app/data/services/dahua_service.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../../../data/models/attendence_record.dart';

class HomeController extends GetxController {
  final DahuaService _dahuaService = DahuaService();

  var isLoading = true.obs;
  var totalEmployees = 0.obs;
  var employeesAtWork = 0.obs;
  var attendanceHistory = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    try {
      isLoading.value = true;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final sevenDaysAgo = today.subtract(const Duration(days: 6));

      final records = await _dahuaService.fetchAttendanceRecords(sevenDaysAgo, now);
      final userRecords = groupBy(records, (AttendanceRecord r) => r.userId);

      totalEmployees.value = userRecords.keys.length;

      int atWorkCount = 0;
      final todayRecords = records.where((r) => r.createTime.isAfter(today)).toList();
      final todayUserRecords = groupBy(todayRecords, (AttendanceRecord r) => r.userId);

      todayUserRecords.forEach((userId, records) {
        if (records.isNotEmpty) {
          records.sort((a, b) => a.createTime.compareTo(b.createTime));
          if (records.length % 2 != 0) {
            atWorkCount++;
          }
        }
      });
      employeesAtWork.value = atWorkCount;

      final history = <int>[];
      for (int i = 0; i < 7; i++) {
        final date = sevenDaysAgo.add(Duration(days: i));
        final dayRecords = records.where((r) => r.createTime.year == date.year && r.createTime.month == date.month && r.createTime.day == date.day).toList();
        final dayUserRecords = groupBy(dayRecords, (AttendanceRecord r) => r.userId);
        history.add(dayUserRecords.keys.length);
      }
      attendanceHistory.value = history;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch attendance data');
    } finally {
      isLoading.value = false;
    }
  }
}
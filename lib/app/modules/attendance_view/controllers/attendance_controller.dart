import 'package:akbulut_admin/app/data/models/employee.dart';
import 'package:akbulut_admin/app/data/services/dahua_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/attendence_record.dart';

class AttendanceController extends GetxController {
  final DahuaService _dahuaService = DahuaService();

  var isLoading = true.obs;
  var allEmployees = <Employee>[].obs;
  var filteredEmployees = <Employee>[].obs;

  var selectedDateRange = Rx<DateTimeRange>(DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 1)),
    end: DateTime.now(),
  ));

  var statusFilter = EmployeeStatus.atWork.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final records = await _dahuaService.fetchAttendanceRecords(
        selectedDateRange.value.start,
        selectedDateRange.value.end,
      );
      _processRecords(records);
      filterEmployees();
    } catch (e) {
      Get.snackbar('Hata', 'Veriler getirilirken bir sorun oluştu: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _processRecords(List<AttendanceRecord> records) {
    final Map<String, List<AttendanceRecord>> userRecords = {};
    for (var record in records) {
      userRecords.putIfAbsent(record.userId, () => []).add(record);
    }

    allEmployees.clear();
    userRecords.forEach((userId, records) {
      records.sort((a, b) => a.createTime.compareTo(b.createTime));
      final employee = Employee(
        userId: userId,
        name: records.first.cardName,
        records: records,
      );

      if (records.isNotEmpty) {
        final lastRecord = records.last;
        if (lastRecord.type == EventType.entry) {
          final now = DateTime.now();
          final lastRecordDate = lastRecord.createTime;
          if (now.year == lastRecordDate.year && now.month == lastRecordDate.month && now.day == lastRecordDate.day) {
            employee.status.value = EmployeeStatus.atWork;
          } else {
            employee.status.value = EmployeeStatus.notAtWork;
          }
        } else {
          employee.status.value = EmployeeStatus.notAtWork;
        }
      } else {
        employee.status.value = EmployeeStatus.notAtWork;
      }

      allEmployees.add(employee);
    });
  }

  void changeStatusFilter(EmployeeStatus? newStatus) {
    if (newStatus != null) {
      statusFilter.value = newStatus;
      filterEmployees();
    }
  }

  void filterEmployees() {
    if (statusFilter.value == EmployeeStatus.unknown) {
      filteredEmployees.value = List.from(allEmployees);
    } else {
      filteredEmployees.value = allEmployees.where((e) => e.status.value == statusFilter.value).toList();
    }
  }

  void pickDateRange() async {
    final newDateRange = await showDateRangePicker(
      context: Get.context!,
      initialDateRange: selectedDateRange.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 1)),
    );

    if (newDateRange != null) {
      selectedDateRange.value = newDateRange;
      fetchData();
    }
  }

  Duration getWorkDurationForDay(Employee employee, DateTime day) {
    final dayRecords = employee.records.where((r) {
      return r.createTime.year == day.year && r.createTime.month == day.month && r.createTime.day == day.day;
    }).toList();

    if (dayRecords.isEmpty) return Duration.zero;

    final firstEntry = dayRecords.firstWhereOrNull((r) => r.type == EventType.entry);
    final lastExitOrEntry = dayRecords.last;

    if (firstEntry != null) {
      return lastExitOrEntry.createTime.difference(firstEntry.createTime);
    }
    return Duration.zero;
  }
}

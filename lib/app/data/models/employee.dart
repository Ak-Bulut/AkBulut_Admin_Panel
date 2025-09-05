import 'package:akbulut_admin/app/data/models/attendence_record.dart';
import 'package:get/get.dart';

enum EmployeeStatus { atWork, notAtWork, unknown }

class Employee {
  final String userId;
  final String name;
  final Rx<EmployeeStatus> status = EmployeeStatus.unknown.obs;
  final List<AttendanceRecord> records;
  String? get imageUrl => records.firstWhereOrNull((r) => r.snapshotUrl != null)?.snapshotUrl;

  Employee({
    required this.userId,
    required this.name,
    this.records = const [],
  });
}

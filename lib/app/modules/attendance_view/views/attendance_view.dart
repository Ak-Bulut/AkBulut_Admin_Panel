import 'package:akbulut_admin/app/data/models/employee.dart';
import 'package:akbulut_admin/app/modules/attendance_view/controllers/attendance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/attendence_record.dart';

class AttendanceView extends StatelessWidget {
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personel Devam Kontrol"),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildDataTable()),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tarih Seçici
          ElevatedButton.icon(
            onPressed: controller.pickDateRange,
            icon: Icon(Icons.calendar_today),
            label: Obx(() => Text("${DateFormat('dd/MM/yyyy').format(controller.selectedDateRange.value.start)} - ${DateFormat('dd/MM/yyyy').format(controller.selectedDateRange.value.end)}")),
          ),

          // Durum Filtresi
          Obx(() => DropdownButton<EmployeeStatus>(
                value: controller.statusFilter.value,
                onChanged: (EmployeeStatus? newValue) {
                  controller.changeStatusFilter(newValue);
                },
                items: [
                  DropdownMenuItem(value: EmployeeStatus.atWork, child: Text("İşte Olanlar")),
                  DropdownMenuItem(value: EmployeeStatus.notAtWork, child: Text("Dışarıda Olanlar")),
                  DropdownMenuItem(value: EmployeeStatus.unknown, child: Text("Tümü")), // Tümü için 'unknown' kullanılıyor
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      if (controller.filteredEmployees.isEmpty) {
        return Center(child: Text("Seçilen kriterlere uygun kayıt bulunamadı."));
      }
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Durum')),
            DataColumn(label: Text('İsim')),
            DataColumn(label: Text('Kullanıcı ID')),
            DataColumn(label: Text('Son Hareket')),
            DataColumn(label: Text('Detay')),
          ],
          rows: controller.filteredEmployees.map((employee) {
            final lastRecord = employee.records.isNotEmpty ? employee.records.last : null;
            return DataRow(cells: [
              DataCell(
                Obx(() => Icon(
                      employee.status.value == EmployeeStatus.atWork ? Icons.check_circle : Icons.cancel,
                      color: employee.status.value == EmployeeStatus.atWork ? Colors.green : Colors.red,
                    )),
              ),
              DataCell(Text(employee.name)),
              DataCell(Text(employee.userId)),
              DataCell(Text(lastRecord != null ? DateFormat('dd/MM HH:mm').format(lastRecord.createTime) : 'Kayıt Yok')),
              DataCell(IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  // Kullanıcı detaylarını gösteren bir dialog aç
                  Get.dialog(_buildEmployeeDetailDialog(employee));
                },
              )),
            ]);
          }).toList(),
        ),
      );
    });
  }

  Widget _buildEmployeeDetailDialog(Employee employee) {
    return AlertDialog(
      title: Text('${employee.name} - Detaylar'),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: employee.records.length,
          itemBuilder: (context, index) {
            final record = employee.records[index];
            return ListTile(
              leading: Icon(
                record.type == EventType.entry ? Icons.login : Icons.logout,
                color: record.type == EventType.entry ? Colors.green : Colors.orange,
              ),
              title: Text(DateFormat('dd/MM/yyyy HH:mm:ss').format(record.createTime)),
              subtitle: Text(record.type.toString().split('.').last),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text('Kapat'),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}

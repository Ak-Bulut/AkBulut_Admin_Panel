import 'package:akbulut_admin/app/product/constants/color_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.kPrimaryColor)),
        backgroundColor: ColorConstants.kPrimaryColor2.withOpacity(0.1),
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCards(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildSummaryCard('total_employees'.tr, controller.totalEmployees.value.toString(), Colors.blue.shade800),
        _buildSummaryCard('at_work'.tr, controller.employeesAtWork.value.toString(), Colors.green.shade800),
        _buildSummaryCard('not_at_work'.tr, (controller.totalEmployees.value - controller.employeesAtWork.value).toString(), Colors.red.shade800),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts() {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: controller.totalEmployees.value.toDouble(),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: controller.employeesAtWork.value.toDouble(), color: Colors.green.shade600, width: 25),
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: (controller.totalEmployees.value - controller.employeesAtWork.value).toDouble(), color: Colors.red.shade600, width: 25),
                    ]),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              String text = '';
                              switch (value.toInt()) {
                                case 0:
                                  text = 'at_work'.tr;
                                  break;
                                case 1:
                                  text = 'not_at_work'.tr;
                                  break;
                              }
                              return Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500));
                            })),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesView extends StatelessWidget {
  const SalesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'SalesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

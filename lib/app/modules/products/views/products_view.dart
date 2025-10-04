import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'ProductsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

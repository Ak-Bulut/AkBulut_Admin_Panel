import 'package:flutter/cupertino.dart';
import 'package:akbulut_admin/app/product/init/packages.dart';

enum ColumnSize { small, medium, large }

@immutable
class StringConstants {
  static const String appName = 'AkBulut HJ Admin Panel';

  static List icons = [
    IconlyLight.chart,
    IconlyLight.paper,
    IconlyLight.search,
    CupertinoIcons.cart_badge_plus,
    IconlyLight.wallet,
    IconlyLight.user3,
    IconlyLight.document,
  ];

  static List selectedIcons = [
    IconlyBold.chart,
    IconlyBold.paper,
    IconlyBold.search,
    CupertinoIcons.cart_fill_badge_plus,
    IconlyBold.wallet,
    IconlyBold.user3,
    IconlyBold.document,
  ];

  static List titles = ['home', 'sales', 'products', 'purchases', 'expences', 'workers', 'logs'];
}

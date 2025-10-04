import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:akbulut_admin/app/product/init/packages.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({super.key, this.onChanged, this.onClear, required this.controller});
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.low,
      child: Card(
        elevation: 0,
        color: Colors.white54.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: ColorConstants.blackColor.withOpacity(0.1))),
        child: ListTile(
          leading: const Icon(
            IconlyLight.search,
            color: Colors.black,
          ),
          title: TextField(
              controller: controller,
              style: TextStyle(color: ColorConstants.blackColor, fontSize: 16, fontWeight: FontWeight.w600),
              decoration: InputDecoration(hintText: 'search'.tr, hintStyle: TextStyle(color: ColorConstants.greyColor, fontSize: 14), border: InputBorder.none),
              onChanged: onChanged),
          contentPadding: EdgeInsets.only(left: 15),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                icon: Icon(
                  CupertinoIcons.xmark_circle,
                  color: ColorConstants.greyColor,
                ),
                onPressed: onClear),
          ),
        ),
      ),
    );
  }
}

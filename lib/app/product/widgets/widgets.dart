import 'package:get/get.dart';
import 'package:akbulut_admin/app/product/constants/string_constants.dart';
import 'package:akbulut_admin/app/product/init/packages.dart';

class CustomWidgets {
  static Center spinKit() {
    return Center(child: Lottie.asset(IconConstants.loading, width: 150, height: 150, animate: true));
  }

  static Center errorData() {
    return const Center(
      child: Text("Error data"),
    );
  }

  static Center noImage() {
    return Center(
        child: Text(
      'noImage'.tr,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 25.sp),
    ));
  }

  int getFlexForSize(String size) {
    if (size == ColumnSize.small.toString()) return 1;
    if (size == ColumnSize.medium.toString()) return 2;
    if (size == ColumnSize.large.toString()) return 3;
    return 1; // default
  }

  static Center emptyData() {
    return Center(
        child: Text(
      "noProduct".tr,
      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20.sp),
    ));
  }

  static SnackbarController showSnackBar(String title, String subtitle, Color color) {
    if (SnackbarController.isSnackbarBeingShown) {
      SnackbarController.cancelAllSnackbars();
    }
    return Get.snackbar(
      title,
      subtitle,
      snackStyle: SnackStyle.FLOATING,
      titleText: title == ''
          ? const SizedBox.shrink()
          : Text(
              title.tr,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
      messageText: Text(
        subtitle.tr,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      borderRadius: 20.0,
      duration: const Duration(milliseconds: 1000),
      margin: const EdgeInsets.all(8),
    );
  }

  static Center errorFetchData(BuildContext context) {
    return Center(
        child: Padding(
      padding: context.padding.normal,
      child: Column(
        children: [
          Lottie.asset(IconConstants.noData, width: WidgetSizes.size256.value, height: WidgetSizes.size256.value, animate: true),
          Padding(
            padding: context.padding.verticalNormal,
            child: Text(
              "Data not found",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "If you want to see the data please check your internet connection",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.general.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 20, color: ColorConstants.greyColor),
          ),
        ],
      ),
    ));
  }

  static Widget counter(int index) {
    return Container(
      width: 40.w,
      padding: EdgeInsets.only(right: 10.w),
      alignment: Alignment.center,
      child: Text(
        index.toString(),
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.sp),
      ),
    );
  }

  static Widget imageWidget(String? url, {bool fit = false, int? cacheWidth, int? cacheHeight}) {
    return CachedNetworkImage(
      imageUrl: url!,
      // Bellekte yeniden boyutlama için:
      memCacheWidth: cacheWidth ?? 200, // örneğin 200px genişlik
      memCacheHeight: cacheHeight ?? 200, // örneğin 200px yükseklik
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: imageProvider,
            fit: fit ? null : BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Center(
          child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(strokeWidth: 2),
      )),
      errorWidget: (context, url, error) => Icon(IconlyLight.infoSquare),
    );
  }
}

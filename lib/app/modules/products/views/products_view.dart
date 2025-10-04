import 'dart:ui';

import 'package:akbulut_admin/app/modules/products/models/category_model.dart';
import 'package:akbulut_admin/app/product/init/packages.dart';
import 'package:akbulut_admin/app/product/widgets/custom_scroll_behavior.dart';
import 'package:akbulut_admin/app/product/widgets/search_widget.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controller/product_controller.dart';
import '../models/product_model.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final ProductController controller = Get.put(ProductController());
  @override
  void initState() {
    super.initState();
    controller.fetchCategories();
    controller.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Column(
        children: [
          SearchWidget(
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
            onClear: () {
              controller.onSearchChanged('');
              controller.searchController.clear();
            },
          ),
          _buildCategoryFilter(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.hasError.value) {
                return Center(child: Text('error_loading_products'.tr));
              } else if (controller.filteredProductList.isEmpty) {
                return Center(child: Text('no_products_found'.tr));
              } else if (controller.isGridView.value) {
                return _buildGridView(controller);
              } else {
                return _buildListView(controller);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return Obx(() {
      if (controller.categoryList.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ScrollConfiguration(
          behavior: AppScrollBehavior(),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categoryList.length + 1,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 16.0 : 4.0, right: 4.0),
                child: Obx(() {
                  if (index == 0) {
                    return _buildCategoryChip(
                      label: 'all'.tr,
                      isSelected: controller.selectedCategory.value == null,
                      onSelected: (_) => controller.selectCategory(null),
                    );
                  }
                  final category = controller.categoryList[index - 1];

                  return _buildCategoryChip(
                    label: category.name,
                    isSelected: controller.selectedCategory.value?.id == category.id,
                    onSelected: (_) => controller.selectCategory(category),
                  );
                }),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: ColorConstants.kPrimaryColor2,
      backgroundColor: ColorConstants.whiteColor,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      labelStyle: TextStyle(
        color: isSelected ? ColorConstants.whiteColor : ColorConstants.greyColor,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? Colors.transparent : ColorConstants.greyColor.withOpacity(0.4),
        width: 1.5,
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'products_view'.tr,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: ColorConstants.blackColor),
      ),
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      backgroundColor: ColorConstants.kPrimaryColor2.withOpacity(0.05),
      elevation: 0,
      actions: [
        Obx(() => ToggleButtons(
              isSelected: [!controller.isGridView.value, controller.isGridView.value],
              onPressed: (index) => controller.toggleView(),
              borderRadius: BorderRadius.circular(6),
              selectedColor: Colors.white,
              fillColor: ColorConstants.whiteColor,
              borderColor: ColorConstants.blackColor.withOpacity(0.1),
              constraints: const BoxConstraints(
                minHeight: 30.0,
                minWidth: 40.0,
              ),
              children: [
                HugeIcon(icon: HugeIcons.strokeRoundedListView, size: 16, color: ColorConstants.blackColor),
                HugeIcon(icon: HugeIcons.strokeRoundedGridView, size: 16, color: ColorConstants.blackColor),
              ],
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton.icon(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedAddCircle, size: 18, color: Colors.black),
            label: Text('add_product'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.white,
              overlayColor: Colors.white,
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(ProductController controller) {
    return Obx(() => ListView.builder(
          itemCount: controller.filteredProductList.length,
          itemBuilder: (context, index) {
            final product = controller.filteredProductList[index];
            return _buildProductListCard(controller, product);
          },
        ));
  }

  Widget _buildGridView(ProductController controller) {
    return Obx(() => GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 2 / 2.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.filteredProductList.length,
          itemBuilder: (context, index) {
            final product = controller.filteredProductList[index];
            return _buildProductGridCard(controller, product);
          },
        ));
  }

  Widget _buildProductListCard(ProductController controller, ProductModel product) {
    return GestureDetector(
      onTap: () {
        controller.showProductDetailsDialog(product);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white, border: Border.all(color: Colors.grey.shade200), boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 4,
          )
        ]),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.imageUrls.isNotEmpty
                    ? Image.network(
                        product.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                      )
                    : const Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(product.category?.name ?? 'no_category'.tr, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.kPrimaryColor, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  _buildStockIndicator(product.stockLeft, isSmall: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGridCard(ProductController controller, ProductModel product) {
    return GestureDetector(
      onTap: () {
        controller.showProductDetailsDialog(product);
      },
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: ColorConstants.blackColor.withOpacity(0.1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: product.imageUrls.isNotEmpty
                    ? Image.network(
                        product.imageUrls.first,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image_not_supported, size: 40)),
                      )
                    : const Center(child: Icon(Icons.image_not_supported, size: 40)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(color: ColorConstants.blackColor.withOpacity(0.1)),
              )),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(product.category?.name.toString() ?? 'no_category'.tr, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.kPrimaryColor, fontSize: 16)),
                      _buildStockIndicator(product.stockLeft, isSmall: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockIndicator(int stock, {bool isSmall = false}) {
    Color color;
    if (stock > 50) {
      color = Colors.green.shade700;
    } else if (stock > 0) {
      color = Colors.orange.shade700;
    } else {
      color = Colors.red.shade700;
    }
    final text = 'stock_count'.tr.replaceAll('@stock', stock.toString());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 6 : 8, vertical: isSmall ? 2 : 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: isSmall ? 14 : 16,
        ),
      ),
    );
  }
}

class AppScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.mouse,
      };

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

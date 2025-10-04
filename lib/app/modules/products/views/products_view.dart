import 'package:akbulut_admin/app/product/init/packages.dart';
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

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'products'.tr,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: ColorConstants.blackColor),
      ),
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: 80,
              height: 80,
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
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(product.category, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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
            // Stock & Price
            SizedBox(
              width: 150, // Fixed width for alignment
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.kPrimaryColor, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  _buildStockIndicator(product.stockLeft),
                ],
              ),
            ),
            // Actions
            _buildActionMenu(controller, product),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGridCard(ProductController controller, ProductModel product) {
    return GestureDetector(
      onTap: () {
        controller.showProductDetails(product);
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(product.category, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
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
    String text;
    if (stock > 50) {
      color = Colors.green.shade700;
      text = 'in_stock'.trParams({'stock': stock.toString()});
    } else if (stock > 0) {
      color = Colors.orange.shade700;
      text = 'low_stock'.trParams({'stock': stock.toString()});
    } else {
      color = Colors.red.shade700;
      text = 'out_of_stock'.tr;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 6 : 8, vertical: isSmall ? 2 : 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: isSmall ? 10 : 12,
        ),
      ),
    );
  }

  Widget _buildActionMenu(ProductController controller, ProductModel product) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'view') {
        } else if (value == 'edit') {
        } else if (value == 'delete') {}
      },
      icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'view',
          child: ListTile(leading: const Icon(HugeIcons.strokeRoundedView), title: Text('view_details'.tr)),
        ),
        PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(leading: const Icon(HugeIcons.strokeRoundedEdit01), title: Text('edit_product'.tr)),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(leading: const Icon(HugeIcons.strokeRoundedDelete01, color: Colors.red), title: Text('delete'.tr, style: const TextStyle(color: Colors.red))),
        ),
      ],
    );
  }
}

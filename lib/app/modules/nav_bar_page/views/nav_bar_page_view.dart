import 'package:akbulut_admin/app/modules/nav_bar_page/controllers/nav_bar_page_controller.dart';
import 'package:akbulut_admin/app/product/constants/string_constants.dart';
import 'package:akbulut_admin/app/product/init/packages.dart';
import 'package:akbulut_admin/app/product/widgets/drawer_button.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

class NavBarPageView extends GetView<NavBarPageController> {
  final NavBarPageController controller = Get.put(NavBarPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          const _DrawerView(),
          Expanded(
            flex: 6,
            child: Obx(() => Container(
                  color: Colors.white,
                  child: controller.pages[controller.selectedIndex.value],
                )),
          ),
        ],
      ),
    );
  }
}

class _DrawerView extends GetView<NavBarPageController> {
  const _DrawerView();
  Future<void> fetchRecords() async {
    var client = DigestAuthClient('admin', 'yoda12345');

    final url = Uri.parse('http://172.16.14.104/cgi-bin/recordFinder.cgi?action=find&name=AccessControlCardRec&StartTime=1756512000');

    client.get(url).then((r) => print(r.body));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool showIconOnly = width < 1000.0;

    return Expanded(
      flex: 1,
      child: Column(
        children: [
          const _Header(),
          Padding(
            padding: context.padding.low,
            child: Divider(color: Colors.amber.withOpacity(0.2), thickness: 2),
          ),
          Expanded(
            flex: 17,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(controller.pages.length, (index) {
                  final isSelected = controller.selectedIndex.value == index;
                  final icon = isSelected ? controller.drawerSelectedIcons[index] : controller.drawerIcons[index];
                  final title = controller.drawerTitles[index];

                  return DrawerButtonMine(
                    onTap: () {
                      controller.changePage(index);
                      fetchRecords();
                    },
                    index: index,
                    selectedIndex: controller.selectedIndex.value,
                    showIconOnly: showIconOnly,
                    icon: icon,
                    title: title,
                  );
                }),
              ),
            ),
          ),
          LanguageButton(), // Assuming LanguageButton is a globally available widget
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 2,
      child: Center(
        child: Text(
          StringConstants.appName,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 28),
        ),
      ),
    );
  }
}

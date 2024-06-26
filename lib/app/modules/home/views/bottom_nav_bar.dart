// // ignore_for_file: file_names, must_be_immutable, always_use_package_imports, avoid_void_async, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:menu_managament_app/app/modules/appInfoPage/views/app_info_page_view.dart';
import 'package:menu_managament_app/app/modules/cartPage/controllers/cart_page_controller.dart';
import 'package:menu_managament_app/app/modules/cartPage/views/cart_page_view.dart';
import 'package:menu_managament_app/app/modules/category/controllers/category_controller.dart';
import 'package:menu_managament_app/app/modules/category/views/category_view.dart';
import 'package:menu_managament_app/app/modules/search/views/search_view.dart';
import 'package:menu_managament_app/app/modules/settings/views/settings_view.dart';
import 'package:menu_managament_app/contants/constants.dart';
import 'package:menu_managament_app/contants/custom_app_bar.dart';
import 'package:menu_managament_app/contants/widgets.dart';

import 'home_view.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;
  List pages = [const HomeView(), CategoryView(), CartPageView(), const AppInfoPageView()];
  List names = ['home', 'category', 'order', 'contactInformation'];
  CategoryController categoryController = Get.put(CategoryController());
  CartPageController cartPageController = Get.put(CartPageController());
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop == false) {
          customAlertDialog(
              context: context,
              title: 'Çykmak',
              subtitle: 'Siz hakykatdan hem programmadan çykmak isleýärsiňizmi ?',
              onYES: () {
                SystemNavigator.pop();
              });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          backArrow: false,
          actionIcon: true,
          icon: buildIcon(context),
          name: "${names[selectedIndex]}".tr,
        ),
        bottomSheet: selectedIndex == 2
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 5, blurRadius: 5)],
                ),
                width: Get.size.width,
                child: Obx(() {
                  double sumPrice = 0.0;
                  print(cartPageController.cartList);
                  for (var element in cartPageController.cartList) {
                    sumPrice += double.parse(element['price'].toString()) * element['quantity'];
                  }
                  sumPrice = sumPrice * (1 + 10 / 100);

                  return Wrap(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hyzmat üçin :',
                            style: TextStyle(fontFamily: gilroyMedium, color: Colors.grey, fontSize: 20),
                          ),
                          Text("10%", style: TextStyle(fontFamily: gilroyMedium, color: Colors.grey, fontSize: 20)),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${'sum'.tr} : ',
                            style: const TextStyle(fontFamily: gilroySemiBold, fontSize: 20),
                          ),
                          Text("${sumPrice.toStringAsFixed(1)} TMT ", style: const TextStyle(fontFamily: gilroySemiBold, fontSize: 20)),
                        ],
                      ),
                    ],
                  );
                }),
              )
            : const SizedBox.shrink(),
        bottomNavigationBar: bottomNavBar(),
        body: Center(
          child: pages[selectedIndex],
        ),
      ),
    );
  }

  BottomNavigationBar bottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      iconSize: 22,
      elevation: selectedIndex == 2 ? 0 : 1,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: kPrimaryColor,
      useLegacyColorScheme: true,
      selectedLabelStyle: const TextStyle(fontFamily: gilroySemiBold, fontSize: 13),
      unselectedLabelStyle: const TextStyle(fontFamily: gilroyMedium, fontSize: 12),
      currentIndex: selectedIndex,
      onTap: (index) async => setState(() => selectedIndex = index),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(IconlyLight.home),
          activeIcon: const Icon(IconlyBold.home),
          label: 'home'.tr,
          tooltip: 'home'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(IconlyLight.category),
          activeIcon: const Icon(IconlyBold.category),
          label: 'category'.tr,
          tooltip: 'category'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(IconlyLight.buy),
          activeIcon: const Icon(IconlyBold.buy),
          label: 'order'.tr,
          tooltip: 'order'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(IconlyLight.infoSquare),
          activeIcon: const Icon(IconlyBold.infoSquare),
          label: 'contactInformation'.tr,
          tooltip: 'contactInformation'.tr,
        ),
      ],
    );
  }

  Widget buildIcon(BuildContext context) {
    if (selectedIndex == 1) {
      return Obx(() {
        return IconButton(
          onPressed: () {
            categoryController.changeList.toggle();
          },
          icon: categoryController.changeList.value ? const Icon(IconlyLight.document) : const Icon(IconlyLight.category),
        );
      });
    } else if (selectedIndex == 2) {
      return IconButton(
        onPressed: () {
          customAlertDialog(
              context: context,
              title: "doYouWantToDeleteCart",
              subtitle: "doYouWantToDeleteCartSubtitle",
              onYES: () {
                if (cartPageController.cartList.isEmpty) {
                  showSnackBar("cartEmpty", "cartEmptySubtitle", Colors.red);
                } else {
                  cartPageController.cartList.clear();
                  cartPageController.refreshCardList();
                  showSnackBar("cartEmpty", "ordersDeleted", Colors.red);
                }
              });
        },
        icon: const Icon(IconlyLight.delete),
      );
    } else if (selectedIndex == 3) {
      return Container(); // No icon for index 3
    } else {
      return Row(
        children: [
          IconButton(
            onPressed: () => Get.to(() => const SearchView()),
            icon: const Icon(IconlyLight.search),
          ),
          IconButton(
            onPressed: () => Get.to(() => SettingsView()),
            icon: const Icon(IconlyLight.setting),
          ),
        ],
      );
    }
  }
}

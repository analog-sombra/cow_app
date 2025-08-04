import 'package:flutter/material.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:gaay/view/sellers/foodhome.dart';
import 'package:gaay/view/sellers/sellerfood.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class FoodCustomBottomNavBars extends HookConsumerWidget {
  const FoodCustomBottomNavBars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        await exitAlert(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
          child: PersistentTabView(
            // navBarHeight: 80,
            // popActionScreens: PopActionScreensType.all,
            tabs: [
              PersistentTabConfig(
                screen: FoodHome(),
                item: ItemConfig(
                  inactiveBackgroundColor: Colors.transparent,
                  inactiveForegroundColor: Colors.transparent,
                  activeForegroundColor: Colors.black,
                  activeColorSecondary: Color(0xffece3dc),
                  icon: Image.asset(
                    "assets/product_tab.png",
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                  title: "Products",
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PersistentTabConfig(
                screen: SellerFood(),
                item: ItemConfig(
                  inactiveBackgroundColor: Colors.transparent,
                  inactiveForegroundColor: Colors.transparent,
                  activeForegroundColor: Colors.black,
                  activeColorSecondary: Color(0xffece3dc),
                  icon: Image.asset(
                    "assets/add_tab.png",
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                  title: "Add Food",
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // PersistentTabConfig(
              //   screen: TreatmentsPage(),
              //   item: ItemConfig(
              //     inactiveBackgroundColor: Colors.transparent,
              //     inactiveForegroundColor: Colors.transparent,
              //     activeForegroundColor: Colors.black,
              //     activeColorSecondary: Color(0xffece3dc),
              //     icon: Image.asset(
              //       "assets/report_tab.png",
              //       width: 24,
              //       fit: BoxFit.contain,
              //     ),
              //     title: "Reports",
              //     textStyle: TextStyle(
              //       fontSize: 15,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              // PersistentTabConfig(
              //   screen: MarketPage(),
              //   item: ItemConfig(
              //     inactiveBackgroundColor: Colors.transparent,
              //     inactiveForegroundColor: Colors.transparent,
              //     activeForegroundColor: Colors.black,
              //     activeColorSecondary: Color(0xffece3dc),
              //     icon: Image.asset(
              //       "assets/tab4.png",
              //       width: 24,
              //       fit: BoxFit.contain,
              //     ),
              //     title: "પશુ બાઝાર",
              //     textStyle: TextStyle(
              //       fontSize: 15,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
            navBarBuilder: (navBarConfig) => Style2BottomNavBar(
              navBarConfig: navBarConfig,
            ),
          ),
        ),
      ),
    );
  }
}

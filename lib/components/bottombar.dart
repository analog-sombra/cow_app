import 'package:flutter/material.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:gaay/view/farmer/course.dart';
import 'package:gaay/view/farmer/home.dart';
import 'package:gaay/view/farmer/market.dart';
import 'package:gaay/view/farmer/treatments.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomBottomNavBars extends HookConsumerWidget {
  const CustomBottomNavBars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final navbarStateW = ref.watch(navbarState);

    // List<PersistentBottomNavBarItem> navBarsItems() {
    //   return [
    //     PersistentBottomNavBarItem(
    //       icon: const Icon(
    //         Icons.home_outlined,
    //       ),
    //       title: 'Home',
    //       activeColorPrimary: primaryColor,
    //     ),
    //     PersistentBottomNavBarItem(
    //       icon: const Icon(
    //         Icons.file_copy_outlined,
    //         size: 18,
    //       ),
    //       title: "Statement",
    //       activeColorPrimary: primaryColor,
    //     ),
    //     PersistentBottomNavBarItem(
    //       icon: Image.asset(
    //         'assets/icons/customer-care.png',
    //         color: primaryColor,
    //         width: 20,
    //       ),
    //       title: "Support",
    //       // textStyle: const TextStyle(fontSize: 19),
    //       activeColorPrimary: primaryColor,
    //     ),
    //     PersistentBottomNavBarItem(
    //       icon: const Icon(CupertinoIcons.person),
    //       title: "Profile",
    //       activeColorPrimary: primaryColor,
    //     ),
    //   ];
    // }

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
                screen: HomePage(),
                item: ItemConfig(
                  inactiveBackgroundColor: Colors.transparent,
                  inactiveForegroundColor: Colors.transparent,
                  activeForegroundColor: Colors.black,
                  activeColorSecondary: Color(0xffece3dc),
                  icon: Image.asset(
                    "assets/tab1.png",
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                  title: "મારી ગાય",
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PersistentTabConfig(
                screen: CoursePage(),
                item: ItemConfig(
                  inactiveBackgroundColor: Colors.transparent,
                  inactiveForegroundColor: Colors.transparent,
                  activeForegroundColor: Colors.black,
                  activeColorSecondary: Color(0xffece3dc),
                  icon: Image.asset(
                    "assets/tab2.png",
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                  title: "જ્ઞાન કેન્દ્ર",
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PersistentTabConfig(
                screen: TreatmentsPage(),
                item: ItemConfig(
                  inactiveBackgroundColor: Colors.transparent,
                  inactiveForegroundColor: Colors.transparent,
                  activeForegroundColor: Colors.black,
                  activeColorSecondary: Color(0xffece3dc),
                  icon: Image.asset(
                    "assets/tab3.png",
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                  title: "પશુચિકિત્સક",
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PersistentTabConfig(
                screen: MarketPage(),
                item: ItemConfig(
                  inactiveBackgroundColor: Colors.transparent,
                  inactiveForegroundColor: Colors.transparent,
                  activeForegroundColor: Colors.black,
                  activeColorSecondary: Color(0xffece3dc),
                  icon: Image.asset(
                    "assets/tab4.png",
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                  title: "પશુ બાઝાર",
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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

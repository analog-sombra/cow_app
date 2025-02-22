import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gaay/state/user_controller.dart';
import 'package:gaay/utils/const.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    AnimationController controller = useAnimationController(
      duration: const Duration(seconds: 1),
    );

    final opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8), // Start slightly off-screen at the bottom
      end: Offset.zero, // End at its original position
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
    ValueNotifier<bool> isLoading = useState(false);

    final userControllerW = ref.watch(userController);
    final user = userControllerW.user;

    Future<void> init() async {
      isLoading.value = true;
      await userControllerW.getUser(context);
      isLoading.value = false;
    }

    useEffect(() {
      controller.forward();
      init();
      return null;
    }, []);

    return Scaffold(
      body: SafeArea(
        child: isLoading.value
            ? Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      // Color(0xffeb7f6b),
                      // Color(0xfffab259),
                      Colors.green,
                      Color(0xff00BFA6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // Positioned(
                    //   top: 5,
                    //   left: 5,
                    //   child: IconButton(
                    //     onPressed: () {
                    //       context.pop();
                    //     },
                    //     icon: Icon(
                    //       Icons.arrow_back,
                    //       size: 40,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    // Positioned(
                    //   top: size.height * 0.1,
                    //   left: size.width * 0.2,
                    //   child: Image.asset(
                    //     "assets/cow.png",
                    //     fit: BoxFit.contain,
                    //     height: size.height * 0.2,
                    //     width: size.width * 0.6,
                    //   ),
                    // ),
                    SizedBox(height: 80),

                    Expanded(
                      child: Container(
                        // height: size.height * 0.6,
                        width: size.width,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(160),
                            topRight: Radius.circular(160),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Transform.translate(
                                      offset: Offset(0, -80),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(150),
                                        child: CachedNetworkImage(
                                          imageUrl: url + user["photo"],
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          width: 160,
                                          height: 160,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(0, -70),
                                    child: Center(
                                      child: Text(
                                        user["name"],
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Opacity(
                                      opacity: opacityAnimation.value,
                                      child: SlideTransition(
                                        position: slideAnimation,
                                        child: Text(
                                          "User Information",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            height: 1,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      // borderRadius: BorderRadius.circular(20),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            // Container(
                                            //   padding: const EdgeInsets.symmetric(
                                            //     horizontal: 10,
                                            //     vertical: 10,
                                            //   ),
                                            //   decoration: BoxDecoration(
                                            //     color: Color(0xffccebcc),
                                            //   ),
                                            //   child: Text(
                                            //     "Details",
                                            //     textAlign: TextAlign.center,
                                            //     style: TextStyle(
                                            //       fontSize: 20,
                                            //       fontWeight: FontWeight.w400,
                                            //     ),
                                            //   ),
                                            // ),
                                            CowTableData(
                                              status: "Name",
                                              title: user["alias"],
                                              isBorder: true,
                                            ),
                                            CowTableData(
                                              status: "Contact",
                                              title: user["contact"] ?? "-",
                                              isBorder: true,
                                            ),
                                            CowTableData(
                                              status: "Beneficiary Code",
                                              title: user["beneficiary_code"] ?? "-",
                                              isBorder: true,
                                            ),
                                            CowTableData(
                                              status: "Address",
                                              title: user["address"] ?? "-",
                                              isBorder: true,
                                            ),
                                            CowTableData(
                                              status: "Village",
                                              title: user["village"] ?? "-",
                                              isBorder: true,
                                            ),
                                            CowTableData(
                                              status: "District",
                                              title: user["district"] ?? "-",
                                              isBorder: true,
                                            ),
                                            // CowTableData(
                                            //   status: "EMI Date",
                                            //   title: "5th Day of Month",
                                            //   isBorder: true,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class CowTableData extends HookConsumerWidget {
  final bool isBorder;
  final String title;
  final String status;
  const CowTableData({
    super.key,
    required this.title,
    required this.status,
    required this.isBorder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            decoration: BoxDecoration(
              color: Color(0xffccebcc),
              border: isBorder
                  ? Border.all(
                      color: Colors.black.withValues(alpha: 0.2),
                    )
                  : null,
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            decoration: BoxDecoration(
              border: isBorder
                  ? Border.all(
                      color: Colors.black.withValues(alpha: 0.2),
                    )
                  : null,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

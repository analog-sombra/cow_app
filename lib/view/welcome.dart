import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gaay/state/auth_controller.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final authControllerW = ref.watch(authController);

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

    useEffect(() {
      controller.forward();
      return null;
    }, []);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/logo.png"),
                    radius: 25, // Larger size for the avatar
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "GAAY APP",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 60,
              left: 0,
              child: Image.asset(
                "assets/lady.jpg",
                fit: BoxFit.cover,
                height: size.height * 0.55,
                width: size.width,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                height: size.height * 0.4,
                width: size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Spacer(),
                        Opacity(
                          opacity: opacityAnimation.value,
                          child: SlideTransition(
                            position: slideAnimation,
                            child: Text(
                              "સ્વાગત છે!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: opacityAnimation.value,
                          child: SlideTransition(
                            position: slideAnimation,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(
                                "હવે તમારું પશુપાલન સરળ અને આધુનિક બનાવો!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Opacity(
                          opacity: opacityAnimation.value,
                          child: SlideTransition(
                            position: slideAnimation,
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                onPressed: () async {
                                  await context.push("/welcome/login");
                                },
                                child: const Text(
                                  'શરૂ કરો',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
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
            )
          ],
        ),
      ),
    );
  }
}

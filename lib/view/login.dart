import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:gaay/state/auth_controller.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final authControllerW = ref.watch(authController);

    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());
    TextEditingController mobile = useTextEditingController();
    TextEditingController otpInputController = useTextEditingController();

    ScrollController scrollController = useScrollController();
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;

    Future<void> startscan() async {
      try {
        var barcodeScanRes = await BarcodeScanner.scan();
        if (!context.mounted) return;
        await authControllerW.login(context, barcodeScanRes.rawContent);
        if (!context.mounted) return;
        context.go("/home");
      } on PlatformException catch (e) {
        if (!context.mounted) return;
        erroralert(context, "Error", e.message!);
      }
    }

    useEffect(() {
      if (isKeyboardShowing && scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
      return () {};
    }, [isKeyboardShowing]);

    final timerValue = useState(60);
    final isTimerRunning = useState(false);
    final noOfTries = useState(3);

    void startTimer(int timerDuartion) {
      Timer? timer;
      timerValue.value = timerDuartion;
      if (isTimerRunning.value) {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (timerValue.value > 0) {
            timerValue.value--; // Decrease the timer value
          } else {
            isTimerRunning.value = false; // Stop the timer when 0
            timer.cancel();
          }
        });
      }
    }

    useEffect(() {
      mobile.text = authControllerW.mobileNumber;
      return null;
    }, []);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10,
                ),
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.cover,
                  height: size.height * 0.30,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              const Text(
                "Enter your details for getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 237, 237),
                          border: Border.all(
                            color: Colors.grey.shade700,
                            width: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                          // horizontal: 20,
                          horizontal: 5,
                        ),
                        child: TextFormField(
                          readOnly: authControllerW.isOtp,
                          validator: (value) {
                            // return null;
                            if (value == "" || value == null || value.isEmpty) {
                              return "Enter Beneficiary Code";
                            }
                            return null;
                          },
                          cursorColor: Colors.black,
                          cursorWidth: 0.8,
                          cursorHeight: 25,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          controller: mobile,
                          decoration: InputDecoration(
                            // icon: Icon(Icons.),
                            filled: false,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade700,
                                width: 0.2,
                              ),
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            label: const Text("Beneficiary Code"),
                            labelStyle: const TextStyle(
                              height: 0.1,
                              color: Color.fromARGB(255, 107, 105, 105),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (authControllerW.isOtp) ...[
                        PinCodeFields(
                          length: 6,
                          responsive: true,
                          controller: otpInputController,
                          fieldBorderStyle: FieldBorderStyle.square,
                          borderRadius: BorderRadius.circular(6),
                          borderWidth: 1,
                          fieldHeight: 50,
                          keyboardType: TextInputType.number,
                          borderColor: const Color.fromARGB(255, 220, 217, 217),
                          fieldBackgroundColor:
                              const Color.fromARGB(255, 240, 237, 237),
                          activeBackgroundColor:
                              const Color.fromARGB(255, 240, 237, 237),
                          activeBorderColor: Colors.blue,
                          onComplete: (pin) async {
                            // final response = await loginControllerW.loginApi(
                            //   context,
                            //   pin,
                            // );

                            // if (response) {
                            //   await ref.read(authController).setLogin(true);
                            //   if (!context.mounted) return;
                            //   context.goNamed(RouteNames.home);
                            // }
                          },
                        ),
                      ],
                      // ------------------- Password -----------------------

                      SizedBox(
                        height: 10,
                      ),
                      if (authControllerW.isOtp) ...[
                        SizedBox(
                          width: size.width - 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                // horizontal: 30,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              await authControllerW.verifyotp(context,
                                  mobile.text, otpInputController.text);
                              if (!context.mounted) return;
                              // await context.push("/home");
                            },
                            child: const Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: size.width - 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                // horizontal: 30,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              // await context.push("/welcome/login");

                              if (!formKey.currentState!.validate()) return;
                              await authControllerW.sendotp(
                                  context, mobile.text);
                              if (isTimerRunning.value) {
                                isTimerRunning.value =
                                    false; // Stop the current timer
                              }
                              isTimerRunning.value = true;
                              startTimer(60);
                              if (!context.mounted) return;
                              doneAlert(context, "Successful",
                                  "OTP sent successfully");
                            },
                            child: const Text(
                              'Send OTP',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.black45,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'OR',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Divider(color: Colors.black45),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width - 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              // horizontal: 30,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: startscan,
                          child: const Text(
                            'Login With QR CODE',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              TextButton(
                onPressed: () async {
                  if (!isTimerRunning.value && noOfTries.value > 0) {
                    await authControllerW.sendotp(context, mobile.text);
                    isTimerRunning.value = true;
                    startTimer(60);
                    noOfTries.value--;
                  } else if (noOfTries.value <= 0) {
                    simpleDoneAlert(
                      context,
                      "You have been reached max tries limit",
                    );
                  }
                },
                child: Text(
                  isTimerRunning.value
                      ? "OTP has bee sent on your sms. Wait for ${timerValue.value}"
                      : "Resend OTP?",
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

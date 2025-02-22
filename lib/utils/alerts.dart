import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaay/state/auth_controller.dart';
import 'package:gaay/state/market_controller.dart';
import 'package:gaay/state/medical_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void erroralert(BuildContext context, String title, String subTitle) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: subTitle,
        contentType: ContentType.failure,
      ),
    ),
  );
}

void simpleDoneAlert(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Row(
      children: [
        Icon(
          Icons.check,
          size: 19,
          color: Colors.white,
        ),
        const SizedBox(
          width: 14,
        ),
        Text(message),
      ],
    )),
  );
}

void doneAlert(BuildContext context, String title, String subTitle) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      backgroundColor: const Color.fromARGB(0, 5, 219, 37),
      content: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
        child: SizedBox(
          height: 160,
          child: AwesomeSnackbarContent(
            title: title,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
            messageTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            message: subTitle,
            contentType: ContentType.success,
          ),
        ),
      ),
    ),
  );
}

Future<void> exitAlert(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        contentPadding: const EdgeInsets.all(5),
        backgroundColor: Colors.white,
        content: Container(
          padding: const EdgeInsets.all(10),
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Exit!",
                  textScaler: TextScaler.linear(1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Are you sure you want to exit the app?',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.55),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          // width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          SystemNavigator.pop();
                        },
                        child: Container(
                          // width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              "Exit",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> treatmentAlert(BuildContext context, WidgetRef ref, int id) async {
  return await showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        contentPadding: const EdgeInsets.all(5),
        backgroundColor: Colors.white,
        content: Container(
          padding: const EdgeInsets.all(10),
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    context.pop();
                    doneAlert(
                      context,
                      "સંદેશો",
                      "તમારી વિનંતી સંદર્ભ નંબર 234533 દ્વારા સફળતાપૂર્વક જનરેટ કરવામાં આવી છે .ડૉક્ટર ટૂંક સમયમાં જ હાજરી આપશે.",
                    );
                    context.pop();
                  },
                  child: Row(
                    children: [
                      const Text(
                        "આરોગ્ય",
                        textScaler: TextScaler.linear(1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: Icon(Icons.close, color: Colors.red, size: 35),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    await ref
                        .watch(medicalController)
                        .createMedicalRequest(context, id, "આરોગ્ય");
                    if (!context.mounted) return;
                    context.pop();
                    doneAlert(
                      context,
                      "સંદેશો",
                      "તમારી વિનંતી સંદર્ભ નંબર દ્વારા સફળતાપૂર્વક જનરેટ કરવામાં આવી છે .ડૉક્ટર ટૂંક સમયમાં જ હાજરી આપશે.",
                    );
                    context.pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xff02cdfd),
                          Color(0xff347fd3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "પશુચિકિત્સકની મુલાકાતની વિનંતી કરો",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        SizedBox(width: 20),
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/medicines.png'),
                          radius: 20,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    await ref
                        .watch(medicalController)
                        .createMedicalRequest(context, id, "આહાર");
                    if (!context.mounted) return;
                    context.pop();
                    doneAlert(
                      context,
                      "સંદેશો",
                      "તમારી વિનંતી સંદર્ભ નંબર દ્વારા સફળતાપૂર્વક જનરેટ કરવામાં આવી છે .ડૉક્ટર ટૂંક સમયમાં જ હાજરી આપશે.",
                    );
                    context.pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xff02cdfd),
                          Color(0xff347fd3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "ગર્ભાધાન વિનંતી",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/semen.png'),
                          radius: 20,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    await ref
                        .watch(medicalController)
                        .createMedicalRequest(context, id, "વાછરડાનો જન્મ");
                    if (!context.mounted) return;
                    context.pop();
                    doneAlert(
                      context,
                      "સંદેશો",
                      "તમારી વિનંતી સંદર્ભ નંબર દ્વારા સફળતાપૂર્વક જનરેટ કરવામાં આવી છે .ડૉક્ટર ટૂંક સમયમાં જ હાજરી આપશે.",
                    );
                    context.pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xff02cdfd),
                          Color(0xff347fd3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "વાછરડાનો જન્મ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/cowbaby.png'),
                          radius: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> logoutAlert(BuildContext context, WidgetRef ref) async {
  return await showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        contentPadding: const EdgeInsets.all(5),
        backgroundColor: Colors.white,
        content: Container(
          padding: const EdgeInsets.all(10),
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Logout!",
                  textScaler: TextScaler.linear(1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.55),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          // width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          ref.watch(authController).setLogin(false);
                        },
                        child: Container(
                          // width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> cowSellAlert(
    BuildContext context, WidgetRef ref, int cowid) async {
  TextEditingController price = TextEditingController();
  return await showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        contentPadding: const EdgeInsets.all(5),
        backgroundColor: Colors.white,
        content: Container(
          padding: const EdgeInsets.all(10),
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Add to marketplace",
                  textScaler: TextScaler.linear(1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1,
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  'Enter sale price',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.55),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  textScaler: const TextScaler.linear(1),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  cursorColor: Colors.black,
                  cursorWidth: 0.8,
                  cursorHeight: 25,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  controller: price,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                        width: 0.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                        width: 0.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                        width: 0.2,
                      ),
                    ),
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    label: const Text("Price"),
                    labelStyle: const TextStyle(
                      height: 0.1,
                      color: Color.fromARGB(255, 107, 105, 105),
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          // width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (price.text.isEmpty) {
                            erroralert(
                                context, "Error", "Please enter the price");
                            return;
                          }
                          await ref.watch(marketController).addMarketCow(
                                context,
                                price.text,
                                cowid,
                              );
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        },
                        child: Container(
                          // width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

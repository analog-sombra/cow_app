// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends HookConsumerWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          "Help",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () async {
              try {
                await logoutAlert(context, ref);
              } catch (e) {
                if (!context.mounted) return;
                erroralert(context, "Error", e.toString());
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Image.asset(
                    "assets/map.jpeg",
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    width: size.width - 40,
                    height: 300,
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 5,
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Toll Fee Number",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (!await launchUrl(Uri.parse("tel:18004254210"))) {}
                        },
                        child: Text(
                          "1800-425-4210",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "For Medical Assistance",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (!await launchUrl(Uri.parse("tel:8905151805"))) {}
                        },
                        child: Text(
                          "+91 8905151805",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (!await launchUrl(Uri.parse("tel:7285038893"))) {}
                        },
                        child: Text(
                          "+91 7285038893",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "For any other assistance And GAAY Loan",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (!await launchUrl(Uri.parse("tel:2602642043"))) {}
                        },
                        child: Text(
                          "+91 260-2642043",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (!await launchUrl(Uri.parse("tel:9808818232"))) {}
                        },
                        child: Text(
                          "+91 9808818232",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (!await launchUrl(Uri.parse("tel:9328207435"))) {}
                        },
                        child: Text(
                          "+91 9328207435",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (!await launchUrl(Uri.parse("tel:9925992989"))) {}
                        },
                        child: Text(
                          "+91 9925992989",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Postal address and Mail",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "DNH DD SC/St OBC & Mino. FDC Ltd 2nd Floor, a-Wing, District Secretariat, Silvassa - 396230",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Website",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (!await launchUrl(
                              Uri.parse("https://http://dnhddscstcorporation.com"))) {}
                        },
                        child: Text(
                          "scstcorporation.com",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Email",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          String? encodeQueryParameters(
                              Map<String, String> params) {
                            return params.entries
                                .map((MapEntry<String, String> e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                .join('&');
                          }

                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'dnhddscst@gmail.com',
                            query: encodeQueryParameters(<String, String>{
                              'subject': 'Assistance Required',
                            }),
                          );

                          launchUrl(emailLaunchUri);
                        },
                        child: Text(
                          "dnhddscst@gmail.com",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )

                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

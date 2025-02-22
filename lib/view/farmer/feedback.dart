// ignore_for_file: constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:gaay/state/feedback_controller.dart';
import 'package:gaay/state/user_controller.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:gaay/utils/const.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum HAPPY { YES, NO }

class FeedBackPage extends HookConsumerWidget {
  const FeedBackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userControllerW = ref.watch(userController);
    final feedbackControllerW = ref.watch(feedbackController);

    final size = MediaQuery.of(context).size;
    ValueNotifier<bool> isLoading = useState(false);

    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());
    TextEditingController description = useTextEditingController();
    TextEditingController suggestion = useTextEditingController();

    ValueNotifier<int> toggleValue = useState<int>(0);
    ValueNotifier<HAPPY> happy = useState<HAPPY>(HAPPY.YES);

    Future<void> init() async {
      isLoading.value = true;
      await userControllerW.getUser(context);
      isLoading.value = false;
    }

    useEffect(() {
      init();
      return null;
    }, []);

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
          "Feedback Form",
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
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey.shade700,
                        width: 0.2,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(60),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: url + userControllerW.user["photo"],
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            width: 45,
                            height: 45,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              userControllerW.user["name"],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                height: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              userControllerW.user["contact"],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Are you satisfied with our service?",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  FlutterToggleTab(
                    unSelectedBackgroundColors: [
                      Colors.grey.shade200,
                      Colors.grey.shade200,
                      Colors.grey.shade200
                    ],
                    marginSelected: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    borderRadius: 5,
                    width: MediaQuery.of(context).size.width * 0.21,
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    unSelectedTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    selectedIndex: toggleValue.value,
                    selectedBackgroundColors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                    // minWidth: 100.0,

                    dataTabs: [
                      DataTab(
                        title: "YES",
                      ),
                      DataTab(
                        title: "NO",
                      ),
                    ],
                    // radiusStyle: true,
                    selectedLabelIndex: (index) {
                      toggleValue.value = index;
                      if (index == 0) {
                        happy.value = HAPPY.YES;
                      } else {
                        happy.value = HAPPY.NO;
                      }
                    },
                    isScroll: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Write your Suggestions",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      // return null;
                      if (value == "" || value == null || value.isEmpty) {
                        return "Enter your suggestion";
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    cursorWidth: 0.8,
                    cursorHeight: 25,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    controller: suggestion,
                    maxLines: 4,
                    minLines: 4,
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      labelStyle: const TextStyle(
                        height: 0.1,
                        color: Color.fromARGB(255, 107, 105, 105),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Message",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      // return null;
                      if (value == "" || value == null || value.isEmpty) {
                        return "Enter your message";
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    cursorWidth: 0.8,
                    cursorHeight: 25,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    maxLines: 4,
                    minLines: 4,
                    controller: description,
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      // label: const Text("Your Message"),
                      labelStyle: const TextStyle(
                        height: 0.1,
                        color: Color.fromARGB(255, 107, 105, 105),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                        if (formKey.currentState!.validate()) {
                          await feedbackControllerW.createFeedBack(
                              context,
                              description.text,
                              suggestion.text,
                              happy.value == HAPPY.YES ? true : false);
                        }

                        suggestion.clear();
                        description.clear();
                        toggleValue.value = 0;
                        if (!context.mounted) return;
                        context.pop();
                      },
                      child: const Text(
                        'Submit',
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
        ),
      ),
    );
  }
}

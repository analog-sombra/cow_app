// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gaay/router/routername.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/state/cow_controller.dart';
import 'package:gaay/state/user_controller.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:gaay/utils/const.dart';
import 'package:gaay/utils/methods.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AddCow extends HookConsumerWidget {
  const AddCow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userControllerW = ref.watch(userController);
    final cowControllerW = ref.watch(cowController);
    final cows = cowControllerW.cows;

    final size = MediaQuery.of(context).size;
    ValueNotifier<bool> isLoading = useState(false);

    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());
    TextEditingController farmer = useTextEditingController();

    ValueNotifier<int> farmerid = useState(0);

    Future<ImageSource?> showImageSourceDialog(BuildContext context) async {
      return await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.image, color: Colors.blue),
              const SizedBox(width: 10),
              const Text(
                "Select Image Source",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          content: const Text(
            "Choose where to get the image from:",
            style: TextStyle(fontSize: 16),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                backgroundColor: Colors.blue, // Camera button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label:
                  const Text("Camera", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                backgroundColor: Colors.green, // Gallery button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              icon: const Icon(Icons.photo_library, color: Colors.white),
              label:
                  const Text("Gallery", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    ValueNotifier<File?> profileImage = useState<File?>(null);
    Future<void> changeImage() async {
      try {
        final ImagePicker picker = ImagePicker();

        // Show an option dialog to choose Camera or Gallery
        final ImageSource? source = await showImageSourceDialog(context);
        if (source == null) return; // User closed the dialog

        final XFile? image = await picker.pickImage(
            source: source,
            requestFullMetadata: false,
            maxHeight: 500,
            maxWidth: 500);
        if (image == null) return;

        // final XFile? imageFile = await compressAndGetImageFile(
        //     File(image.path), image.path.split('/').last);

        // if (imageFile == null) {
        //   if (context.mounted) {
        //     erroralert(context, "Error", 'Failed to pick image try again');
        //   }
        //   return;
        // }

        // final int imagesize = await imageFile.length();
        // const int maxSizeInBytes = 1 * 1024 * 1024; // 1 MB

        // if (imagesize > maxSizeInBytes) {
        //   if (context.mounted) {
        //     erroralert(context, "Error", 'Image size should be less than 1 MB');
        //   }
        //   return;
        // }
        // profileImage.value = File(imageFile.path);
        profileImage.value = File(image.path);

        final responseimag =
            await uploadFile(profileImage.value!, farmerid.value.toString());
        if (!responseimag.status) {
          isLoading.value = false;
          if (!context.mounted) return;
          return erroralert(context, "Error", responseimag.message);
        }
        if (!context.mounted) return;
        await userControllerW.editUserPhoto(
          context,
          farmerid.value,
          responseimag.data,
        );

        if (!context.mounted) return;
        await userControllerW.getFarmerByCode(
          context,
          farmer.text,
        );
      } on PlatformException catch (_) {
        if (context.mounted) {
          erroralert(context, "Error", 'Failed to pick image try again');
        }
      }
    }

    Future<void> init() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String code = packageInfo.buildNumber;

      // show version snakerbar
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Version: $version ($code)"),
          duration: const Duration(seconds: 5),
        ),
      );
    }

    useEffect(() {
      init();
      return null;
    }, []);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        await exitAlert(context);
      },
      child: Scaffold(
        floatingActionButton: userControllerW.user != null
            ? FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {
                  context.pushNamed(
                    RouteNames.farmercows,
                    pathParameters: {
                      "id": userControllerW.user["id"].toString()
                    },
                  );
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            : null,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Dashboard",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.pushNamed(RouteNames.doctorhome);
              },
              child: Text(
                "Doctor",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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
        backgroundColor: Color(0xfffaf5f1),
        body: isLoading.value
            ? Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: size.width * 0.72,
                                  child: TextFormField(
                                    readOnly: userControllerW.user != null,
                                    // onTap: startscan,
                                    cursorColor: Colors.black,
                                    cursorWidth: 0.8,
                                    cursorHeight: 25,
                                    keyboardType: TextInputType.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                    controller: farmer,
                                    decoration: InputDecoration(
                                      // suffix: userControllerW.user != null
                                      //     ? InkWell(
                                      //         onTap: () async {
                                      //           farmerid.value = 0;
                                      //           userControllerW.resetUser();
                                      //         },
                                      //         child: Icon(Icons.edit),
                                      //       )
                                      //     : InkWell(
                                      //         onTap: () async {},
                                      //         child: Icon(Icons.search),
                                      //       ),
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
                                          const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 20),
                                      label: const Text("Farmer Id"),
                                      labelStyle: const TextStyle(
                                        height: 0.1,
                                        color:
                                            Color.fromARGB(255, 107, 105, 105),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                if (userControllerW.user != null) ...[
                                  ElevatedButton(
                                    onPressed: () async {
                                      farmerid.value = 0;
                                      userControllerW.resetUser();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 15,
                                      ),
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ] else ...[
                                  ElevatedButton(
                                    onPressed: () async {
                                      isLoading.value = true;
                                      if (farmer.text.isEmpty) {
                                        erroralert(
                                          context,
                                          "Error",
                                          "Please enter farmer code",
                                        );
                                        isLoading.value = false;

                                        return;
                                      } else {
                                        final res = await userControllerW
                                            .getFarmerByCode(
                                          context,
                                          farmer.text,
                                        );
                                        if (res) {
                                          farmerid.value =
                                              userControllerW.user["id"];
                                          if (!context.mounted) return;
                                          await cowControllerW.getUserCowsById(
                                              context,
                                              userControllerW.user["id"]);
                                        }

                                        isLoading.value = false;
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 15,
                                      ),
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (userControllerW.user != null) ...[
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
                                  if (userControllerW.user["photo"] !=
                                      null) ...[
                                    InkWell(
                                      onTap: changeImage,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(60),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: url +
                                              userControllerW.user["photo"],
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          width: 45,
                                          height: 45,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(60),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],

                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        longText(
                                            userControllerW.user["name"], 22),
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
                                  ),
                                  Spacer(),
                                  // Icon(
                                  //   Icons.arrow_forward_ios,
                                  //   size: 20,
                                  //   color: Colors.black,
                                  // )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "મારી ગાય",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                              textScaler: TextScaler.linear(1),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (cows.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Text(
                                    "કોઈ ગાય મળી નથી",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textScaler: TextScaler.linear(1),
                                  ),
                                ),
                              ),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                for (var cow in cows)
                                  CowCard(
                                    id: cow["id"],
                                    photo: cow["photocover"],
                                    name: longText(cow["cowname"], 16),
                                    cowstatus: cow["cowstatus"],
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class CowCard extends HookConsumerWidget {
  final int id;
  final String photo;
  final String name;
  final String cowstatus;
  const CowCard({
    super.key,
    required this.photo,
    required this.name,
    required this.id,
    required this.cowstatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        // context.pushNamed(
        //   RouteNames.details,
        //   pathParameters: {"id": id.toString()},
        // );
        context.pushNamed(
          RouteNames.editcow,
          pathParameters: {"id": id.toString()},
        );
      },
      child: Container(
        width: (size.width * 0.53) - 40,
        height: (size.width * 0.53) - 30,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: cowstatus == "ALIVE"
                ? Colors.green
                : cowstatus == "DEAD"
                    ? Colors.red
                    : Colors.orange,
            width: 3,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: url + photo,
                height: 105,
                // width: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 10),
            Text(
              longText(name, 10),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 1,
                fontWeight: FontWeight.w400,
              ),
              textScaler: TextScaler.linear(1),
            ),
          ],
        ),
      ),
    );
  }
}

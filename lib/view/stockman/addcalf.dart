import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/state/cow_controller.dart';
import 'package:gaay/state/user_controller.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// calf => male
// heifer => Female
enum GENDER { HEIFER, CALF }

enum COWSTATUS { ALIVE, DEAD, SOLD }

class AddCalf extends HookConsumerWidget {
  final int id;
  const AddCalf({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    ValueNotifier<bool> isLoading = useState(false);

    final userControllerW = ref.watch(userController);
    final cowControllerW = ref.watch(cowController);

// new data start from here

    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());

    TextEditingController tagname = useTextEditingController();
    TextEditingController name = useTextEditingController();
    TextEditingController dob = useTextEditingController();
    // TextEditingController milk = useTextEditingController();
    TextEditingController weight = useTextEditingController();

    TextEditingController lastVaccine = useTextEditingController();
    TextEditingController lastTreatment = useTextEditingController();
    TextEditingController lastDeworming = useTextEditingController();
    TextEditingController lastSickness = useTextEditingController();
    TextEditingController foodMouth = useTextEditingController();
    TextEditingController hemorrhagicSepticemia = useTextEditingController();
    TextEditingController blackQuarter = useTextEditingController();
    TextEditingController brucellossisDate = useTextEditingController();

    TextEditingController insuranceId = useTextEditingController();
    TextEditingController insuranceName = useTextEditingController();
    TextEditingController insuranceType = useTextEditingController();
    TextEditingController insuranceAmount = useTextEditingController();
    TextEditingController insuranceDate = useTextEditingController();
    TextEditingController insuranceRenewalDate = useTextEditingController();
    TextEditingController insuranceRenewalAmount = useTextEditingController();
    TextEditingController premiumAmount = useTextEditingController();
    TextEditingController fathercowid = useTextEditingController();
    ValueNotifier<bool> isInsurance = useState<bool>(false);

    ValueNotifier<int> toggleValue = useState<int>(1);
    ValueNotifier<GENDER> gender = useState<GENDER>(GENDER.HEIFER);

    // image section start from here
    ValueNotifier<File?> profileImage = useState<File?>(null);

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

        profileImage.value = File(image.path);
      } on PlatformException catch (_) {
        if (context.mounted) {
          erroralert(context, "Error", 'Failed to pick image try again');
        }
      }
    }

    Future<void> dateChange(TextEditingController dateData) async {
      // block future date
      DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale('en', 'IN'),
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        if (!context.mounted) return;
        // formate date dd-mm-yyyy
        // dob.text = picked.toString();
        dateData.text = "${picked.day}-${picked.month}-${picked.year}";
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isLoading.value
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor:
                  Colors.transparent, // To blend with the background
              centerTitle: true,
              title: Row(
                children: [
                  Text(
                    // "${user["alias"]} cows",
                    "Add Calf",
                    textScaler: TextScaler.linear(1),
                    style: TextStyle(
                      fontSize: 22,
                      height: 1,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
      body: SafeArea(
        child: isLoading.value
            ? Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: profileImage.value == null
                                    ? CircleAvatar(
                                        backgroundColor: Colors.grey.shade200,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.black,
                                          size: 40,
                                        ),
                                      )
                                    : Image.file(
                                        profileImage.value!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await changeImage();
                                },
                                focusColor: Colors.white,
                                hoverColor: Colors.white,
                                splashColor: Colors.white,
                                // overlayColor: Colors.white,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.3),
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Add Cow Photo",
                                      textScaler: const TextScaler.linear(1),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          validator: (value) {
                            // return null;
                            if (value == "" || value == null || value.isEmpty) {
                              return "Enter Cow Tag Number";
                            }
                            return null;
                          },
                          cursorColor: Colors.black,
                          cursorWidth: 0.8,
                          cursorHeight: 25,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          controller: tagname,
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
                            label: const Text("Tag number"),
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
                        TextFormField(
                          validator: (value) {
                            // return null;
                            if (value == "" || value == null || value.isEmpty) {
                              return "Enter Cow Name";
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
                          controller: name,
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
                            label: const Text("Cow Name"),
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

                        // Create date of birth date picker
                        TextFormField(
                          onTap: () => dateChange(dob),
                          readOnly: true,
                          validator: (value) {
                            // return null;
                            if (value == "" || value == null || value.isEmpty) {
                              return "Enter Cow Date of Birth";
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
                          controller: dob,
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
                            label: const Text("Date of Birth"),
                            labelStyle: const TextStyle(
                              height: 0.1,
                              color: Color.fromARGB(255, 107, 105, 105),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // TextFormField(
                        //   validator: (value) {
                        //     // return null;
                        //     if (value == "" ||
                        //         value == null ||
                        //         value.isEmpty) {
                        //       return "Enter Cow Daily Milk";
                        //     }
                        //     return null;
                        //   },
                        //   cursorColor: Colors.black,
                        //   cursorWidth: 0.8,
                        //   cursorHeight: 25,
                        //   keyboardType: TextInputType.number,
                        //   style: const TextStyle(
                        //     color: Colors.black,
                        //     fontSize: 16.0,
                        //   ),
                        //   controller: milk,
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.grey.shade200,
                        //     border: OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //         color: Colors.grey.shade700,
                        //         width: 0.2,
                        //       ),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //         color: Colors.grey.shade700,
                        //         width: 0.2,
                        //       ),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //         color: Colors.grey.shade700,
                        //         width: 0.2,
                        //       ),
                        //     ),
                        //     errorBorder: InputBorder.none,
                        //     disabledBorder: InputBorder.none,
                        //     contentPadding: const EdgeInsets.symmetric(
                        //         vertical: 8, horizontal: 20),
                        //     label: const Text("Daily Milk (Ltrs)"),
                        //     labelStyle: const TextStyle(
                        //       height: 0.1,
                        //       color: Color.fromARGB(255, 107, 105, 105),
                        //       fontSize: 16.0,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            // return null;
                            if (value == "" || value == null || value.isEmpty) {
                              return "Enter Cow Weight";
                            }
                            return null;
                          },
                          cursorColor: Colors.black,
                          cursorWidth: 0.8,
                          cursorHeight: 25,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          controller: weight,
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
                            label: const Text("Weight (Kgs)"),
                            labelStyle: const TextStyle(
                              height: 0.1,
                              color: Color.fromARGB(255, 107, 105, 105),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                              title: "CALF",
                            ),
                            DataTab(
                              title: "HEIFER",
                            ),
                          ],
                          selectedLabelIndex: (index) {
                            toggleValue.value = index;
                            if (index == 0) {
                              gender.value = GENDER.CALF;
                            } else {
                              gender.value = GENDER.HEIFER;
                            }
                          },
                          isScroll: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          // validator: (value) {
                          //   // return null;
                          //   if (value == "" ||
                          //       value == null ||
                          //       value.isEmpty) {
                          //     return "Enter Bull A.I. ID";
                          //   }
                          //   return null;
                          // },
                          cursorColor: Colors.black,
                          cursorWidth: 0.8,
                          cursorHeight: 25,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          controller: fathercowid,
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
                            label: const Text("Bull A.I. ID"),
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
                        DateTextController(
                          controller: lastDeworming,
                          label: "Last Deworming Date",
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DateTextController(
                          controller: lastTreatment,
                          label: "Last Treatment Date",
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DateTextController(
                          controller: lastVaccine,
                          label: "Last Vaccine Date",
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // DateTextController(
                        //   controller: lastCalf,
                        //   label: "Last Calf Date",
                        //   firstDate: DateTime(2015, 8),
                        //   lastDate: DateTime.now(),
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        DateTextController(
                          controller: lastSickness,
                          label: "Last Sickness Date",
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DateTextController(
                          controller: foodMouth,
                          label: "Last Foot & Mouth Date",
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DateTextController(
                          controller: hemorrhagicSepticemia,
                          label: "Last Hemorrhagic Septicemia Date",
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 500)),
                          lastDate: DateTime.now(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DateTextController(
                          controller: blackQuarter,
                          label: "Last Black Quarter Date",
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 500)),
                          lastDate: DateTime.now(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (gender.value == GENDER.HEIFER) ...[
                          DateTextController(
                            controller: brucellossisDate,
                            label: "Last Brucellossis Date",
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime.now(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],

                        // DateTextController(
                        //   controller: heatPeriod,
                        //   label: "Last Heat Period Date",
                        //   firstDate: DateTime.now()
                        //       .subtract(const Duration(days: 45)),
                        //   lastDate: DateTime.now(),
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),

                        const SizedBox(
                          height: 20,
                        ),

                        // is insurance checkebox
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey.shade700,
                              width: 0.2,
                            ),
                          ),
                          child: CheckboxListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text(
                              "Insurance Available",
                              textScaler: TextScaler.linear(1),
                              style: TextStyle(
                                fontSize: 18,
                                height: 1,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            value: isInsurance.value,
                            onChanged: (value) {
                              isInsurance.value = value!;
                            },
                          ),
                        ),
                        if (isInsurance.value) ...[
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Insurance Details",
                            textScaler: TextScaler.linear(1),
                            style: TextStyle(
                              fontSize: 22,
                              height: 1,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (value) {
                              // return null;
                              if (value == "" ||
                                  value == null ||
                                  value.isEmpty) {
                                return "Enter Insurance ID";
                              }
                              return null;
                            },
                            cursorColor: Colors.black,
                            cursorWidth: 0.8,
                            cursorHeight: 25,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            controller: insuranceId,
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
                              label: const Text("Insurance ID"),
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
                          TextFormField(
                            validator: (value) {
                              // return null;
                              if (value == "" ||
                                  value == null ||
                                  value.isEmpty) {
                                return "Enter Insurance Company Name";
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
                            controller: insuranceName,
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
                              label: const Text("Insurance Company Name"),
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
                          TextFormField(
                            validator: (value) {
                              // return null;
                              if (value == "" ||
                                  value == null ||
                                  value.isEmpty) {
                                return "Enter Insurance Type";
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
                            controller: insuranceType,
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
                              label: const Text("Insurance Type"),
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
                          InsuranceDateTextController(
                            controller: insuranceDate,
                            label: "Insurance Date",
                            insuranceRenewalDate: insuranceRenewalDate,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (value) {
                              // return null;
                              if (value == "" ||
                                  value == null ||
                                  value.isEmpty) {
                                return "Enter Insurance Amount";
                              }
                              return null;
                            },
                            cursorColor: Colors.black,
                            cursorWidth: 0.8,
                            cursorHeight: 25,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            controller: insuranceAmount,
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
                              label: const Text("Insurance Amount"),
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
                          TextFormField(
                            validator: (value) {
                              // return null;
                              if (value == "" ||
                                  value == null ||
                                  value.isEmpty) {
                                return "Enter Insurance Premium Amount";
                              }
                              return null;
                            },
                            cursorColor: Colors.black,
                            cursorWidth: 0.8,
                            cursorHeight: 25,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            controller: premiumAmount,
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
                              label: const Text("Insurance Premium Amount"),
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
                          InsuranceRenewalDateTextController(
                            controller: insuranceRenewalDate,
                            label: "Insurance Renewal Date",
                            insuranceDate: insuranceDate,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (value) {
                              // return null;
                              if (value == "" ||
                                  value == null ||
                                  value.isEmpty) {
                                return "Enter Insurance Renewal Amount";
                              }
                              return null;
                            },
                            cursorColor: Colors.black,
                            cursorWidth: 0.8,
                            cursorHeight: 25,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            controller: insuranceRenewalAmount,
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
                              label: const Text("Insurance Renewal Amount"),
                              labelStyle: const TextStyle(
                                height: 0.1,
                                color: Color.fromARGB(255, 107, 105, 105),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],

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
                              if (profileImage.value == null) {
                                erroralert(context, "Error",
                                    "Please select cow photo");
                                return;
                              }

                              if (dob.text.isEmpty) {
                                erroralert(context, "Error",
                                    "Please select cow date of birth");
                                return;
                              }

                              if (isInsurance.value) {
                                if (insuranceId.text.isEmpty) {
                                  erroralert(context, "Error",
                                      "Please enter insurance id");
                                  return;
                                }

                                if (insuranceName.text.isEmpty) {
                                  erroralert(context, "Error",
                                      "Please enter insurance company name");
                                  return;
                                }

                                if (insuranceType.text.isEmpty) {
                                  erroralert(context, "Error",
                                      "Please enter insurance type");
                                  return;
                                }

                                if (insuranceAmount.text.isEmpty) {
                                  erroralert(context, "Error",
                                      "Please enter insurance amount");
                                  return;
                                }

                                if (insuranceRenewalAmount.text.isEmpty) {
                                  erroralert(context, "Error",
                                      "Please enter insurance renewal amount");
                                  return;
                                }

                                if (premiumAmount.text.isEmpty) {
                                  erroralert(context, "Error",
                                      "Please enter insurance premium amount");
                                  return;
                                }

                                if (insuranceDate.text.isEmpty) {
                                  erroralert(context, "Error",
                                      "Please select insurance date");
                                  return;
                                }

                                if (insuranceRenewalDate.text.isEmpty) {
                                  erroralert(context, "Error",
                                      "Please select insurance renewal date");
                                  return;
                                }

                                // premium amount should be less then insurance amount
                                if (insuranceAmount.text.isNotEmpty &&
                                    insuranceRenewalAmount.text.isNotEmpty) {
                                  if (double.parse(
                                          insuranceRenewalAmount.text) >
                                      double.parse(insuranceAmount.text)) {
                                    erroralert(context, "Error",
                                        "Insurance renewal amount should be less then insurance amount");
                                    return;
                                  }
                                }

                                // premium amount should be less then insurance amount
                                if (insuranceAmount.text.isNotEmpty &&
                                    premiumAmount.text.isNotEmpty) {
                                  if (double.parse(premiumAmount.text) >
                                      double.parse(insuranceAmount.text)) {
                                    erroralert(context, "Error",
                                        "Insurance Premium amount should be less then insurance amount");
                                    return;
                                  }
                                }
                              }

                              if (formKey.currentState!.validate()) {
                                final responseimag = await uploadFile(
                                    profileImage.value!, id.toString());
                                if (!responseimag.status) {
                                  isLoading.value = false;
                                  if (context.mounted) {
                                    return erroralert(
                                        context, "Error", responseimag.message);
                                  }
                                }

                                if (!context.mounted) return;

                                await cowControllerW.addCowCalf(context, {
                                  "cowid": id,
                                  "cowname": name.text,
                                  "cowtagno": tagname.text,
                                  "breedid": 1,
                                  "sex": toggleValue.value == 0
                                      ? "MALE"
                                      : "FEMALE",
                                  "cowstatus": "ALIVE",
                                  "birthdate": convertToDate(dob.text),
                                  "daily_milk_produce": "0",
                                  "weight": weight.text,
                                  "farmerid": userControllerW.user["id"],
                                  "createdById": await userControllerW
                                      .getCurrentUserId(context),
                                  "photocover": responseimag.data,
                                  "alias": name.text,
                                  "status": "ACTIVE",
                                  "noofcalves": 0,
                                  ...(lastVaccine.text.isNotEmpty
                                      ? {
                                          "last_vaccine_date":
                                              convertToDate(lastVaccine.text),
                                        }
                                      : {}),
                                  ...(lastTreatment.text.isNotEmpty
                                      ? {
                                          "last_treatment_date":
                                              convertToDate(lastTreatment.text),
                                        }
                                      : {}),
                                  ...(lastSickness.text.isNotEmpty
                                      ? {
                                          "last_sickness_date":
                                              convertToDate(lastSickness.text),
                                        }
                                      : {}),
                                  ...(foodMouth.text.isNotEmpty
                                      ? {
                                          "food_and_mouth_date":
                                              convertToDate(foodMouth.text),
                                        }
                                      : {}),
                                  ...(hemorrhagicSepticemia.text.isNotEmpty
                                      ? {
                                          "hemorrhagic_septicemia_date":
                                              convertToDate(
                                                  hemorrhagicSepticemia.text),
                                        }
                                      : {}),
                                  ...(blackQuarter.text.isNotEmpty
                                      ? {
                                          "black_quarter_date":
                                              convertToDate(blackQuarter.text),
                                        }
                                      : {}),
                                  "last_calf_birthdate":
                                      DateTime(1901, 1, 1).toIso8601String(),
                                  "brucellossis_date": gender.value ==
                                          GENDER.HEIFER
                                      ? brucellossisDate.text.isEmpty ||
                                              brucellossisDate.text == ""
                                          ? DateTime(1901, 1, 1)
                                              .toIso8601String()
                                          : convertToDate(brucellossisDate.text)
                                      : DateTime(1901, 1, 1).toIso8601String(),
                                  "heat_period":
                                      DateTime(1901, 1, 1).toIso8601String(),
                                  "insurance_id": insuranceId.text,
                                  "insurance_name": insuranceName.text,
                                  "insurance_type": insuranceType.text,
                                  "insurance_amount": insuranceAmount.text,
                                  "insurance_date": insuranceDate.text == ""
                                      ? null
                                      : convertToDate(insuranceDate.text),
                                  "insurance_renewal_date":
                                      insuranceRenewalDate.text == ""
                                          ? null
                                          : convertToDate(
                                              insuranceRenewalDate.text),
                                  "insurance_renewal_amount":
                                      insuranceRenewalAmount.text,
                                  "premium_amount": premiumAmount.text,
                                  "fathercowid": fathercowid.text.isEmpty ||
                                          fathercowid.text == ""
                                      ? "NA"
                                      : fathercowid.text,
                                });
                                if (!context.mounted) return;
                                await cowControllerW.getUserCowsById(
                                    context, userControllerW.user["id"]);

                                // reset all fields
                                tagname.clear();
                                name.clear();
                                dob.clear();
                                // milk.clear();
                                weight.clear();

                                lastVaccine.clear();
                                lastTreatment.clear();
                                lastDeworming.clear();
                                // lastCalf.clear();
                                lastSickness.clear();
                                foodMouth.clear();
                                hemorrhagicSepticemia.clear();
                                blackQuarter.clear();
                                brucellossisDate.clear();
                                // heatPeriod.clear();

                                // soldcontact.clear();
                                // soldprice.clear();
                                // soldto.clear();
                                // solddate.clear();
                                // deathdate.clear();

                                insuranceId.clear();
                                insuranceName.clear();
                                insuranceType.clear();
                                insuranceAmount.clear();
                                insuranceDate.clear();
                                insuranceRenewalDate.clear();
                                insuranceRenewalAmount.clear();
                                premiumAmount.clear();

                                profileImage.value = null;
                                toggleValue.value = 0;
                                if (!context.mounted) return;
                                context.pop();
                              }
                            },
                            child: const Text(
                              'Add Cow',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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

class DateTextController extends HookConsumerWidget {
  final TextEditingController controller;
  final String label;
  final DateTime firstDate;
  final DateTime lastDate;
  const DateTextController({
    super.key,
    required this.controller,
    required this.label,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> cowDateChange(TextEditingController dateData) async {
      // block future date
      DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale('en', 'IN'),
        initialDate: DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate,
      );
      if (picked != null) {
        if (!context.mounted) return;
        // formate date dd-mm-yyyy
        // dob.text = picked.toString();
        dateData.text = "${picked.day}-${picked.month}-${picked.year}";
      }
    }

    return TextFormField(
      onTap: () => cowDateChange(controller),
      readOnly: true,
      cursorColor: Colors.black,
      cursorWidth: 0.8,
      cursorHeight: 25,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
      controller: controller,
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
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        label: Text(label),
        labelStyle: const TextStyle(
          height: 0.1,
          color: Color.fromARGB(255, 107, 105, 105),
          fontSize: 16.0,
        ),
      ),
    );
  }
}

class InsuranceDateTextController extends HookConsumerWidget {
  final TextEditingController controller;
  final String label;
  final TextEditingController insuranceRenewalDate;

  const InsuranceDateTextController({
    super.key,
    required this.controller,
    required this.label,
    required this.insuranceRenewalDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> cowDateChange(TextEditingController dateData) async {
      // block future date
      DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale('en', 'IN'),
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        if (!context.mounted) return;
        // formate date dd-mm-yyyy
        // dob.text = picked.toString();
        dateData.text = "${picked.day}-${picked.month}-${picked.year}";
      }
    }

    return TextFormField(
      onTap: () {
        cowDateChange(controller);
        insuranceRenewalDate.clear();
      },
      readOnly: true,
      cursorColor: Colors.black,
      cursorWidth: 0.8,
      cursorHeight: 25,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
      controller: controller,
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
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        label: Text(label),
        labelStyle: const TextStyle(
          height: 0.1,
          color: Color.fromARGB(255, 107, 105, 105),
          fontSize: 16.0,
        ),
      ),
    );
  }
}

class InsuranceRenewalDateTextController extends HookConsumerWidget {
  final TextEditingController controller;
  final TextEditingController insuranceDate;
  final String label;

  const InsuranceRenewalDateTextController({
    super.key,
    required this.controller,
    required this.label,
    required this.insuranceDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> cowDateChange(TextEditingController dateData) async {
      // block future date
      DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale('en', 'IN'),
        initialDate: DateTime.now(),
        firstDate: insuranceDate.text.isNotEmpty
            ? DateTime.parse(convertToDate(insuranceDate.text))
            : DateTime(2000, 1, 1),
        lastDate: DateTime(2100, 12, 31),
      );
      if (picked != null) {
        if (!context.mounted) return;
        // formate date dd-mm-yyyy
        // dob.text = picked.toString();
        dateData.text = "${picked.day}-${picked.month}-${picked.year}";
      }
    }

    return TextFormField(
      onTap: () {
        if (insuranceDate.text.isEmpty) {
          erroralert(context, "Error",
              "Please select insurance date before selecting renewal date");
          return;
        }
        cowDateChange(controller);
      },
      readOnly: true,
      cursorColor: Colors.black,
      cursorWidth: 0.8,
      cursorHeight: 25,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
      controller: controller,
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
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        label: Text(label),
        labelStyle: const TextStyle(
          height: 0.1,
          color: Color.fromARGB(255, 107, 105, 105),
          fontSize: 16.0,
        ),
      ),
    );
  }
}

String convertToDate(String dateString) {
  List<String> parts = dateString.split('-');
  if (parts.length != 3) {
    throw FormatException("Invalid date format. Expected DD-MM-YYYY");
  }

  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);

  return DateTime(year, month, day).toIso8601String();
}

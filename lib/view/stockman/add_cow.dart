// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/state/cow_controller.dart';
import 'package:gaay/state/user_controller.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:gaay/utils/const.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// enum GENDER { MALE, FEMALE }

class AddCow extends HookConsumerWidget {
  const AddCow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userControllerW = ref.watch(userController);
    final cowControllerW = ref.watch(cowController);

    final size = MediaQuery.of(context).size;
    ValueNotifier<bool> isLoading = useState(false);

    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());
    TextEditingController farmer = useTextEditingController();
    TextEditingController tagname = useTextEditingController();
    TextEditingController name = useTextEditingController();
    TextEditingController dob = useTextEditingController();
    TextEditingController milk = useTextEditingController();
    TextEditingController weight = useTextEditingController();

    TextEditingController lastVaccine = useTextEditingController();
    TextEditingController lastTreatment = useTextEditingController();
    TextEditingController lastDeworming = useTextEditingController();
    TextEditingController lastSickness = useTextEditingController();
    TextEditingController foodMouth = useTextEditingController();
    TextEditingController HemorrhagicSepticemia = useTextEditingController();
    TextEditingController blackQuarter = useTextEditingController();
    TextEditingController brucellossinDate = useTextEditingController();
    TextEditingController lastCalf = useTextEditingController();
    TextEditingController heatPeriod = useTextEditingController();

    ValueNotifier<int> toggleValue = useState<int>(0);
    // ValueNotifier<GENDER> gender = useState<GENDER>(GENDER.MALE);
    ValueNotifier<int> farmerid = useState(0);

    // image section start from here
    ValueNotifier<File?> profileImage = useState<File?>(null);
    Future<void> changeImage() async {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;
        profileImage.value = File(image.path);
      } on PlatformException catch (e) {
        if (context.mounted) {
          erroralert(context, "Error", 'Failed to pick image: $e');
        }
      }
    }

    Future<void> dateChange(TextEditingController dateData) async {
      // block future date
      DateTime? picked = await showDatePicker(
        context: context,
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          "Add Cattle",
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
                children: [
                  TextFormField(
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
                      suffix: userControllerW.user != null
                          ? InkWell(
                              onTap: () async {
                                farmerid.value = 0;
                                userControllerW.resetUser();
                              },
                              child: Icon(Icons.edit),
                            )
                          : InkWell(
                              onTap: () async {
                                if (farmer.text.isEmpty) {
                                  erroralert(
                                    context,
                                    "Error",
                                    "Please enter farmer code",
                                  );
                                  return;
                                } else {
                                  await userControllerW.getFarmerByCode(
                                    context,
                                    farmer.text,
                                  );
                                  farmerid.value = userControllerW.user["id"];
                                }
                              },
                              child: Icon(Icons.search),
                            ),
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
                      label: const Text("Farmer Id"),
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
                  ],

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
                              border:
                                  Border.all(color: Colors.grey, width: 0.3),
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      // return null;
                      if (value == "" || value == null || value.isEmpty) {
                        return "Enter Cow Daily Milk";
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
                    controller: milk,
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
                      label: const Text("Daily Milk (Ltrs)"),
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
                      label: const Text("Daily Weight (Kgs)"),
                      labelStyle: const TextStyle(
                        height: 0.1,
                        color: Color.fromARGB(255, 107, 105, 105),
                        fontSize: 16.0,
                      ),
                    ),
                  ),

                  // FlutterToggleTab(
                  //   unSelectedBackgroundColors: [
                  //     Colors.grey.shade200,
                  //     Colors.grey.shade200,
                  //     Colors.grey.shade200
                  //   ],
                  //   marginSelected: EdgeInsets.symmetric(
                  //     horizontal: 6,
                  //     vertical: 6,
                  //   ),
                  //   borderRadius: 5,
                  //   width: MediaQuery.of(context).size.width * 0.21,
                  //   selectedTextStyle: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  //   unSelectedTextStyle: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500),
                  //   selectedIndex: toggleValue.value,
                  //   selectedBackgroundColors: [
                  //     Colors.black.withValues(alpha: 0.6),
                  //     Colors.black.withValues(alpha: 0.6),
                  //   ],
                  //   // minWidth: 100.0,

                  //   dataTabs: [
                  //     DataTab(
                  //       title: "MALE",
                  //     ),
                  //     DataTab(
                  //       title: "FEMALE",
                  //     ),
                  //   ],
                  //   // radiusStyle: true,
                  //   selectedLabelIndex: (index) {
                  //     toggleValue.value = index;
                  //     if (index == 0) {
                  //       gender.value = GENDER.MALE;
                  //     } else {
                  //       gender.value = GENDER.FEMALE;
                  //     }
                  //   },
                  //   isScroll: false,
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateTextController(
                    controller: lastDeworming,
                    label: "Last Deworming Date",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateTextController(
                    controller: lastTreatment,
                    label: "Last Treatment Date",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateTextController(
                    controller: lastVaccine,
                    label: "Last Vaccine Date",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateTextController(
                    controller: lastCalf,
                    label: "Last Calf Date",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateTextController(
                    controller: lastSickness,
                    label: "Last Sickness Date",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateTextController(
                    controller: foodMouth,
                    label: "Last Food Mouth Date",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateTextController(
                    controller: HemorrhagicSepticemia,
                    label: "Last Hemorrhagic Septicemia Date",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateTextController(
                    controller: blackQuarter,
                    label: "Last Black Quarter Date",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateTextController(
                    controller: brucellossinDate,
                    label: "Last Brucellossin Date",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateTextController(
                    controller: heatPeriod,
                    label: "Last Heat Period Date",
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
                        if (farmerid.value == 0) {
                          erroralert(
                              context, "Error", "Please enter farmer code");
                          return;
                        }

                        if (profileImage.value == null) {
                          erroralert(
                              context, "Error", "Please select cow photo");
                          return;
                        }

                        final responseimag = await uploadFile(
                            profileImage.value!, farmerid.value.toString());
                        if (!responseimag.status) {
                          isLoading.value = false;
                          if (context.mounted) {
                            return erroralert(
                                context, "Error", responseimag.message);
                          }
                        }

                        if (formKey.currentState!.validate()) {
                          if (!context.mounted) return;

                          await cowControllerW.addCow(context, {
                            "cowname": name.text,
                            "cowtagno": tagname.text,
                            "breedid": 1,
                            "sex": "FEMALE",
                            "birthdate": dob.text,
                            "daily_milk_produce": milk.text,
                            "weight": weight.text,
                            "farmerid": farmerid.value,
                            "photocover": responseimag.data,
                            "alias": name.text,
                            "status": "ACTIVE",
                            "noofcalves": 0,
                            "last_treatment_date": lastTreatment.text,
                            "last_vaccine_date": lastVaccine.text,
                            "last_deworming_date": lastDeworming.text,
                            "last_calf_birthdate": lastCalf.text,
                            "last_sickness_date": lastSickness.text,
                            "food_and_mouth_date": foodMouth.text,
                            "hemorrhagic_septicemia_date":
                                HemorrhagicSepticemia.text,
                            "black_quarter_date": blackQuarter.text,
                            "brucellossis_date": brucellossinDate.text,
                            "heat_period": heatPeriod.text,
                          });
                        }

                        // reset all fields
                        farmer.clear();
                        tagname.clear();
                        name.clear();
                        dob.clear();
                        milk.clear();
                        weight.clear();

                        lastVaccine.clear();
                        lastTreatment.clear();
                        lastDeworming.clear();
                        lastCalf.clear();
                        lastSickness.clear();
                        foodMouth.clear();
                        HemorrhagicSepticemia.clear();
                        blackQuarter.clear();
                        brucellossinDate.clear();
                        heatPeriod.clear();

                        profileImage.value = null;
                        toggleValue.value = 0;
                      },
                      child: const Text(
                        'Add Cattle',
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

class DateTextController extends HookConsumerWidget {
  final TextEditingController controller;
  final String label;
  const DateTextController({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> cowDateChange(TextEditingController dateData) async {
      // block future date
      DateTime? picked = await showDatePicker(
        context: context,
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

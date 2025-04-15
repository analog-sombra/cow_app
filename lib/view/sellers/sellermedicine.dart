import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/state/cow_controller.dart';
import 'package:gaay/state/market_controller.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum SizeUnit {
  ML,
  LITRE,
  KG,
  GRAM,
  PIECE,
}

class SellerMedicine extends HookConsumerWidget {
  const SellerMedicine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cowControllerW = ref.watch(cowController);
    final marketControllerW = ref.watch(marketController);

    final size = MediaQuery.of(context).size;
    ValueNotifier<bool> isLoading = useState(false);

    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());

    TextEditingController name = useTextEditingController();
    TextEditingController dataSize = useTextEditingController();
    ValueNotifier<SizeUnit> sizeUnit = useState(SizeUnit.ML);
    TextEditingController packSize = useTextEditingController();
    TextEditingController mrp = useTextEditingController();
    TextEditingController description = useTextEditingController();
    TextEditingController purpose = useTextEditingController();
    TextEditingController composition = useTextEditingController();
    TextEditingController manufacturer = useTextEditingController();
    TextEditingController largeDescription = useTextEditingController();
    TextEditingController purchasePrice = useTextEditingController();
    TextEditingController dosage = useTextEditingController();

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
          "Add Medicine",
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
                                "Add Medicine Photo",
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
                        return "Enter Medicine Name";
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
                      label: const Text("Name"),
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
                        return "Enter Size";
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
                    controller: dataSize,
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
                      label: const Text("Size"),
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
                        return "Enter Pack Size";
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
                    controller: dosage,
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
                      label: const Text("Pack Size"),
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
                        return "Enter Dosage";
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
                    controller: packSize,
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
                      label: const Text("Dosage"),
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
                  // create a drop down for unit size
                  Container(
                    width: double.infinity, // Make it full width
                    padding: EdgeInsets.symmetric(
                        horizontal: 20), // Add horizontal padding
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Gray background color
                      borderRadius: BorderRadius.circular(
                          8), // Rounded corners (optional)
                      border: Border.all(
                        color: Colors.grey.shade700,
                        width: 0.2, // Border width
                      ),
                    ),
                    child: DropdownButton<SizeUnit>(
                      value: sizeUnit.value,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      menuMaxHeight: size.height -
                          40, // Adjust max height of dropdown menu
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: const SizedBox(), // Remove underline
                      onChanged: (SizeUnit? newValue) {
                        if (!context.mounted) return;
                        sizeUnit.value = newValue!;
                      },
                      items: SizeUnit.values
                          .map<DropdownMenuItem<SizeUnit>>((SizeUnit value) {
                        return DropdownMenuItem<SizeUnit>(
                          value: value,
                          child: Text(
                            value.toString().split('.').last,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      // return null;
                      if (value == "" || value == null || value.isEmpty) {
                        return "mrp";
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
                    controller: mrp,
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
                      label: const Text("MRP"),
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
                        return "purpose";
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
                    controller: purpose,
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
                      label: const Text("Purpose"),
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
                        return "composition";
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
                    controller: composition,
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
                      label: const Text("Composition"),
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
                        return "manufacturer";
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
                    controller: manufacturer,
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
                      label: const Text("Manufacturer"),
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
                        return "Purchase Price";
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
                    controller: purchasePrice,
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
                      label: const Text("Purchase Price"),
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0;
                              i < marketControllerW.images.length;
                              i++) ...[
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 8),
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.15),
                                          blurRadius: 5)
                                    ]),
                                    width: 80,
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        marketControllerW.images[i],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      marketControllerW.removeImage(
                                          marketControllerW.images[i]);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (marketControllerW.images.length < 5) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () async {
                                  await marketControllerW.addImage(context);
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.15),
                                      )
                                    ],
                                  ),
                                  width: 80,
                                  height: 80,
                                  child: const Center(
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: Text("Descrilption",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        )),
                  ),
                  TextFormField(
                    validator: (value) {
                      // return null;
                      if (value == "" || value == null || value.isEmpty) {
                        return "description";
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    cursorWidth: 0.8,
                    cursorHeight: 25,
                    minLines: 3,
                    // expands: true,
                    maxLines: 6,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
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
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: Text("Long Descrilption",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        )),
                  ),

                  TextFormField(
                    validator: (value) {
                      // return null;
                      if (value == "" || value == null || value.isEmpty) {
                        return "Large Description";
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    cursorWidth: 0.8,
                    minLines: 6,
                    maxLines: 20,
                    cursorHeight: 25,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    controller: largeDescription,
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
                        if (profileImage.value == null) {
                          erroralert(
                              context, "Error", "Please select medicine photo");
                          return;
                        }

                        final responseimag = await uploadFile(
                            profileImage.value!, "medicinemarket");
                        if (!responseimag.status) {
                          isLoading.value = false;
                          if (context.mounted) {
                            return erroralert(
                              context,
                              "Error",
                              responseimag.message,
                            );
                          }
                        }

                        if (formKey.currentState!.validate()) {
                          if (!context.mounted) return;

                          await marketControllerW.addMarketMedicine(context, {
                            "name": name.text,
                            "size": dataSize.text,
                            "pack_size": packSize.text,
                            "mrp": mrp.text,
                            "cover": responseimag.data,
                            "description": description.text,
                            "size_unit":
                                sizeUnit.value.toString().split('.').last,
                            "purpose": purpose.text,
                            "dosage": dosage.text,
                            "composition": composition.text,
                            "manufacturer": manufacturer.text,
                            "large_description": largeDescription.text,
                            "purchase_price": purchasePrice.text,
                          });
                        }

                        // reset all fields
                        name.clear();
                        dataSize.clear();
                        packSize.clear();
                        mrp.clear();
                        description.clear();
                        purpose.clear();
                        composition.clear();
                        manufacturer.clear();
                        largeDescription.clear();
                        purchasePrice.clear();
                        marketControllerW.clearImages();
                        profileImage.value = null;
                      },
                      child: const Text(
                        'Add Medicine',
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

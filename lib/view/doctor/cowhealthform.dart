import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gaay/state/cow_controller.dart';
import 'package:gaay/state/market_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CowHealthForm extends HookConsumerWidget {
  final int id;
  const CowHealthForm({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cowControllerW = ref.watch(cowController);
    final marketControllerW = ref.watch(marketController);

    final size = MediaQuery.of(context).size;
    ValueNotifier<bool> isLoading = useState(false);

    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());

    TextEditingController treatmentProvided = useTextEditingController();
    TextEditingController followupdate = useTextEditingController();
    TextEditingController followuptreatment = useTextEditingController();

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
          "Add Treatment",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
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
                    validator: (value) {
                      // return null;
                      if (value == "" || value == null || value.isEmpty) {
                        return "Enter Vaccine Name";
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
                    controller: treatmentProvided,
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
                      label: const Text("Treatment Provided"),
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
                    controller: followupdate,
                    label: "Follow Up Date",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      // return null;
                      if (value == "" || value == null || value.isEmpty) {
                        return "Enter Follow up treatment";
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
                    controller: followuptreatment,
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
                      label: const Text("Follow Up treatment"),
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
                        // if (profileImage.value == null) {
                        //   erroralert(
                        //       context, "Error", "Please select food photo");
                        //   return;
                        // }

                        // final responseimag =
                        //     await uploadFile(profileImage.value!, "foodmarket");
                        // if (!responseimag.status) {
                        //   isLoading.value = false;
                        //   if (context.mounted) {
                        //     return erroralert(
                        //       context,
                        //       "Error",
                        //       responseimag.message,
                        //     );
                        //   }
                        // }

                        // if (formKey.currentState!.validate()) {
                        //   if (!context.mounted) return;

                        //   await marketControllerW.addMarketFood(context, {
                        //     "name": name.text,
                        //     "size": dataSize.text,
                        //     "pack_size": packSize.text,
                        //     "mrp": mrp.text,
                        //     "cover": responseimag.data,
                        //     "description": description.text,
                        //     "size_unit":
                        //         sizeUnit.value.toString().split('.').last,
                        //     "purpose": purpose.text,
                        //     "composition": composition.text,
                        //     "manufacturer": manufacturer.text,
                        //     "large_description": largeDescription.text,
                        //     "purchase_price": purchasePrice.text,
                        //   });
                        // }

                        // // reset all fields
                        // name.clear();
                        // dataSize.clear();
                        // packSize.clear();
                        // mrp.clear();
                        // description.clear();
                        // purpose.clear();
                        // composition.clear();
                        // manufacturer.clear();
                        // largeDescription.clear();
                        // purchasePrice.clear();
                        // marketControllerW.clearImages();
                        // profileImage.value = null;
                      },
                      child: const Text(
                        'Add Treatment',
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

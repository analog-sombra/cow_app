import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final marketController = ChangeNotifierProvider.autoDispose<MarketController>(
    (ref) => MarketController());

class MarketController extends ChangeNotifier {
  List<dynamic> marketcows = [];
  List<dynamic> marketfoods = [];
  List<dynamic> marketmedicine = [];
  Future<void> addMarketCow(
    BuildContext context,
    String price,
    int cowid,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    if (id == null) {
      if (!context.mounted) return;
      erroralert(context, "Error", "User id not found");
      return;
    }
    int userid = int.parse(id);

    final response = await apiCall(
      query:
          "mutation AddMarketCow(\$createMarketInput:CreateMarketInput!){addMarketCow (createMarketInput:\$createMarketInput){ id }} ",
      variables: {
        "createMarketInput": {
          "farmerid": userid,
          "cowid": cowid,
          "price": price,
          "verified": true,
          "remarks": "cow for sale",
          "status": "ACTIVE",
        }
      },
      headers: {"content-type": "*/*"},
    );
    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }
    if (!context.mounted) return;
    doneAlert(context, 160, "Successful", "Cow added to market successfully");

    notifyListeners();
  }

  Future<void> getUserCows(BuildContext context) async {
    final response = await apiCall(
      query:
          "query GetMarketCow{getMarketCow { id, farmer { contact }, cow {id, photocover, noofcalves, cowname, cowtagno, birthdate, daily_milk_produce }, price, verified, listingdate }}",
      variables: {},
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    marketcows = response.data["getMarketCow"];

    notifyListeners();
  }

  Future<void> getMarketFoods(BuildContext context) async {
    final response = await apiCall(
      query:
          "query GetMarketFood{getMarketFood { id, name, sale_price, cover, size, description, purpose }}",
      variables: {},
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    marketfoods = response.data["getMarketFood"];

    notifyListeners();
  }

  Future<void> getMarketMedicine(BuildContext context) async {
    final response = await apiCall(
      query:
          "query GetMarketMedicine{getMarketMedicine { id, name, sale_price, cover, size, description, purpose }}",
      variables: {},
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    marketmedicine = response.data["getMarketMedicine"];

    notifyListeners();
  }

  Future<void> addMarketFood(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    if (id == null) {
      if (!context.mounted) return;
      erroralert(context, "Error", "User id not found");
      return;
    }
    int userid = int.parse(id);

    Map<String, String> photodata = {};
    for (var i = 0; i < images.length; i++) {
      final response = await uploadFile(images[i], "medicine");
      if (!response.status) {
        if (!context.mounted) return;
        erroralert(context, "Error", response.message);
        return;
      }
      photodata["photo${i + 1}"] = response.data;
    }

    final response = await apiCall(
      query:
          "mutation CreateMarketFood(\$createFoodInput:CreateFoodInput!){createMarketFood (createFoodInput:\$createFoodInput){ id }}",
      variables: {
        "createFoodInput": {
          "name": data["name"],
          "cover": data["cover"],
          "size": data["size"],
          "size_unit": data["size_unit"],
          "pack_size": data["pack_size"],
          "mrp": data["mrp"],
          "description": data["description"],
          "purpose": data["purpose"],
          "composition": data["composition"],
          "manufacturer": data["manufacturer"],
          "large_description": data["large_description"],
          ...photodata,
          "purchase_price": data["purchase_price"],
          "createdById": userid,
          "status": "ACTIVE",
        }
      },
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    if (!context.mounted) return;
    doneAlert(context, 160, "Successful", "Food added to market successfully");

    notifyListeners();
  }

  Future<void> addMarketMedicine(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    if (id == null) {
      if (!context.mounted) return;
      erroralert(context, "Error", "User id not found");
      return;
    }
    int userid = int.parse(id);

    Map<String, String> photodata = {};
    for (var i = 0; i < images.length; i++) {
      final response = await uploadFile(images[i], "medicine");
      if (!response.status) {
        if (!context.mounted) return;
        erroralert(context, "Error", response.message);
        return;
      }
      photodata["photo${i + 1}"] = response.data;
    }

    final response = await apiCall(
      query:
          "mutation CreateMarketMedicine(\$createMedicineInput:CreateMedicineInput!){createMarketMedicine (createMedicineInput:\$createMedicineInput){ id }}",
      variables: {
        "createMedicineInput": {
          "name": data["name"],
          "cover": data["cover"],
          "size": data["size"],
          "size_unit": data["size_unit"],
          "pack_size": data["pack_size"],
          "mrp": data["mrp"],
          "description": data["description"],
          "purpose": data["purpose"],
          "dosage": data["dosage"],
          "composition": data["composition"],
          "manufacturer": data["manufacturer"],
          "large_description": data["large_description"],
          ...photodata,
          "purchase_price": data["purchase_price"],
          "createdById": userid,
          "status": "ACTIVE",
        }
      },
      headers: {"content-type": "*/*"},
    );
    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }
    if (!context.mounted) return;
    doneAlert(
      context,
      160,
      "Successful",
      "Medicine added to market successfully",
    );

    notifyListeners();
  }

  List<File> images = [];
  Future<void> addImage(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemp = File(image.path);
    int sizeInBytes = imageTemp.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > 2) {
      if (!context.mounted) return;
      erroralert(context, "Error", "Image file Size should be less then 2 MB");
      return;
    } else {
      images.add(imageTemp);
    }
    notifyListeners();
  }

  void removeImage(File file) {
    images.remove(file);
    notifyListeners();
  }

  void clearImages() {
    images.clear();
    notifyListeners();
  }

  Future<void> getMarketMedicineByUser(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    if (id == null) {
      if (!context.mounted) return;
      erroralert(context, "Error", "User id not found");
      return;
    }
    int userid = int.parse(id);
    final response = await apiCall(
      query:
          "query GetMarketMedicineByUser(\$getMarketMedicineByUserId:Int!){getMarketMedicineByUser(id:\$getMarketMedicineByUserId) { id, name, purchase_price, cover, size, description, purpose }}",
      variables: {
        "getMarketMedicineByUserId": userid,
      },
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    marketmedicine = response.data["getMarketMedicineByUser"];

    notifyListeners();
  }

  Future<void> getMarketFoodByUser(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    if (id == null) {
      if (!context.mounted) return;
      erroralert(context, "Error", "User id not found");
      return;
    }
    int userid = int.parse(id);
    final response = await apiCall(
      query:
          "query GetMarketFoodByUser(\$getMarketFoodByUserId:Int!){getMarketFoodByUser(id:\$getMarketFoodByUserId) { id, name, purchase_price, cover, size, description, purpose }}",
      variables: {
        "getMarketFoodByUserId": userid,
      },
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    marketfoods = response.data["getMarketFoodByUser"];

    notifyListeners();
  }

  Future<void> getMarketCowByUser(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    if (id == null) {
      if (!context.mounted) return;
      erroralert(context, "Error", "User id not found");
      return;
    }
    int userid = int.parse(id);
    final response = await apiCall(
      query:
          "query GetMarketCowByUser(\$getMarketCowByUserId:Int!){getMarketCowByUser(id:\$getMarketCowByUserId) { id, cow {id, photocover, noofcalves, cowname, cowtagno, birthdate, daily_milk_produce }, price, verified, listingdate }}",
      variables: {
        "getMarketCowByUserId": userid,
      },
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    marketcows = response.data["getMarketCowByUser"];

    notifyListeners();
  }

  Future<void> getAllMarketCowByUser(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    if (id == null) {
      if (!context.mounted) return;
      erroralert(context, "Error", "User id not found");
      return;
    }
    int userid = int.parse(id);
    final response = await apiCall(
      query:
          "query GetAllMarketCowByUser(\$id:Int!){getAllMarketCowByUser(id:\$id) { id, cow {id, photocover, noofcalves, cowname, cowtagno, birthdate, daily_milk_produce }, price, verified, listingdate }}",
      variables: {
        "id": userid,
      },
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    

    marketcows = response.data["getAllMarketCowByUser"];

    notifyListeners();
  }
}

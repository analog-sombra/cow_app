import 'package:flutter/material.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userController = ChangeNotifierProvider.autoDispose<UserController>(
    (ref) => UserController());

class UserController extends ChangeNotifier {
  dynamic user;
  List<dynamic> course = [];

  void resetUser() {
    user = null;
    notifyListeners();
  }

  Future<void> getUser(BuildContext context) async {
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
          "query GetUser(\$id:Int!){getUserById (id:\$id){ id, role, name, contact, alias, photo, address, village, district, beneficiary_code }} ",
      variables: {"id": userid},
      headers: {"content-type": "*/*"},
    );
    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    user = response.data["getUserById"];

    notifyListeners();
  }

  Future<void> getFarmerByCode(BuildContext context, String code) async {
    final response = await apiCall(
      query:
          "query GetFarmerByCode(\$code:String!){ getFarmerByCode(code:\$code){ id, role, name, contact, alias, photo, address, village, district, beneficiary_code }} ",
      variables: {"code": code},
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }
    user = response.data["getFarmerByCode"];
    notifyListeners();
  }

  Future<void> getAllLearn(BuildContext context) async {
    final response = await apiCall(
      query: "query GetAllLearn{ getAllLearn{ id, type, title, link, cover }} ",
      variables: {},
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }
    course = response.data["getAllLearn"];
    notifyListeners();
  }
}

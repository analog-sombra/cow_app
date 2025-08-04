import 'package:flutter/material.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final medicalController = ChangeNotifierProvider.autoDispose<MedicalController>(
    (ref) => MedicalController());

class MedicalController extends ChangeNotifier {
  List<dynamic> cows = [];

  Future<void> createMedicalRequest(
    BuildContext context,
    int cowid,
    String reason,
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
          "mutation CreateMedical(\$createMedicalInput:CreateMedicalInput!){createMedical (createMedicalInput:\$createMedicalInput){ id }} ",
      variables: {
        "createMedicalInput": {
          "farmerid": userid,
          "cowid": cowid,
          "reason": reason,
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
    doneAlert(context, 160, "Successful", "Feedback submitted successfully");

    notifyListeners();
  }

  Future<void> completeMedicalRequest(
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

    final response = await apiCall(
      query:
          "mutation CompleteMedicalRequest(\$completeMedicalInput:CompleteMedicalInput!){completeMedicalRequest (completeMedicalInput:\$completeMedicalInput){ id }} ",
      variables: {
        "completeMedicalInput": {
          "id": data["id"],
          "follow_up_date": data["follow_up_date"],
          "follow_up_treatment": data["follow_up_treatment"],
          "treatment_provided": data["treatment_provided"],
          "user_id": userid,
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
    doneAlert(context, 160, "Successful", "Feedback submitted successfully");

    notifyListeners();
  }

  Future<void> getDoctorMedicalRequest(
    BuildContext context,
    String type,
  ) async {
    Logger().d("Fetching doctor medical request for type: $type");
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
          "query GetDoctorMedicalRequest(\$id:Int!,\$type:String!){getDoctorMedicalRequest (id:\$id,type:\$type){  id, reason, date, type, medicalStatus, type, cow {  photocover,cowname}, farmer {name}}}",
      variables: {
        "type": type,
        "id": userid,
      },
      headers: {"content-type": "*/*"},
    );
    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    cows = response.data["getDoctorMedicalRequest"];

    notifyListeners();
  }
}

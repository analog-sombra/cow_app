import 'package:flutter/material.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final medicalController = ChangeNotifierProvider.autoDispose<MedicalController>(
    (ref) => MedicalController());

class MedicalController extends ChangeNotifier {
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
}

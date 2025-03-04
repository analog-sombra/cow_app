import 'package:flutter/material.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final feedbackController =
    ChangeNotifierProvider.autoDispose<FeedbackController>(
        (ref) => FeedbackController());

class FeedbackController extends ChangeNotifier {
  Future<void> createFeedBack(
    BuildContext context,
    String description,
    String suggestion,
    bool happy,
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
          "mutation CreateFeedback(\$createFeedbackInput:CreateFeedbackInput!){createFeedback (createFeedbackInput:\$createFeedbackInput){ id }} ",
      variables: {
        "createFeedbackInput": {
          "createdById": userid,
          "description": description,
          "suggestion": suggestion,
          "happy": happy,
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
    doneAlert(context, 160,"Successful", "Feedback submitted successfully");

    notifyListeners();
  }
}

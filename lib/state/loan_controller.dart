import 'package:flutter/material.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final loanController = ChangeNotifierProvider.autoDispose<LoanController>(
    (ref) => LoanController());

class LoanController extends ChangeNotifier {
  dynamic loan;

  void resetLoan() {
    loan = null;
    notifyListeners();
  }

  Future<void> getUserLoan(BuildContext context) async {
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
          "query GetUserCurrentLoan(\$id:Int!){getUserCurrentLoan (id:\$id){ id, amount, emi_amount, emi_date, end_date, loan_id, start_date, status }} ",
      variables: {"id": userid},
      headers: {"content-type": "*/*"},
    );
    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    loan = response.data["getUserCurrentLoan"];

    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cowController =
    ChangeNotifierProvider.autoDispose<CowController>((ref) => CowController());

class CowController extends ChangeNotifier {
  dynamic cow;
  List<dynamic> cows = [];

  Future<void> getUserCows(BuildContext context) async {
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
          "query GetUserCows(\$getUserCowsId:Int!){getUserCows (id:\$getUserCowsId){ id, cowname, breed { name }, daily_milk_produce, photocover, cow_health_report { black_quarter_date, brucellossis_date, food_and_mouth_date, heat_period, last_calf_birthdate, last_deworming_date, last_sickness_date, last_treatment_date, last_vaccine_date, hemorrhagic_septicemia_date}}} ",
      variables: {"getUserCowsId": userid},
      headers: {"content-type": "*/*"},
    );

    // , last_vaccine_date, last_treatment_date,  last_deworming_date, 	heat_period,  last_calf_birthdate

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    cows = response.data["getUserCows"];

    notifyListeners();
  }

  Future<void> getCow(BuildContext context, int id) async {
    final response = await apiCall(
      query:
          "query GetCowById(\$id:Int!){getCowById (id:\$id){ id, cowname, breed { name }, photocover, sex, birthdate, cowtagno, noofcalves, weight, daily_milk_produce, cow_health_report { black_quarter_date, brucellossis_date, food_and_mouth_date, heat_period, last_calf_birthdate, last_deworming_date, last_sickness_date, last_treatment_date, last_vaccine_date, hemorrhagic_septicemia_date }}} ",
      variables: {"id": id},
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    cow = response.data["getCowById"];

    notifyListeners();
  }

  Future<void> addCow(BuildContext context, Map<String, dynamic> data) async {
    final response = await apiCall(
      query:
          "mutation CreateCow(\$createCowInput: CreateCowInput!){ createCow(createCowInput:\$createCowInput){ id }}",
      variables: {"createCowInput": data},
      headers: {"content-type": "*/*"},
    );
    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }
    if (!context.mounted) return;
    doneAlert(context,160, "Completed", "New Cow Added Successfully");
    notifyListeners();
  }
}

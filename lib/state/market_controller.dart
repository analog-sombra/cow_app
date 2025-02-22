import 'package:flutter/material.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/web.dart';
import 'package:shared_preferences/shared_preferences.dart';

final marketController = ChangeNotifierProvider.autoDispose<MarketController>(
    (ref) => MarketController());

class MarketController extends ChangeNotifier {

  List<dynamic> marketcows = [];
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
    doneAlert(context, "Successful", "Cow added to market successfully");

    notifyListeners();
  }

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
          "query GetMarketCow{getMarketCow { id, cow {id, photocover, noofcalves, cowname, cowtagno, birthdate, daily_milk_produce }, price, verified, listingdate }}",
      variables: {"getUserCowsId": userid},
      headers: {"content-type": "*/*"},
    );

    if (!response.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", response.message);
      return;
    }

    marketcows = response.data["getMarketCow"];
    Logger().i(response.data["getMarketCow"]);

    notifyListeners();
  }


}

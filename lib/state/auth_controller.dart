import 'package:flutter/material.dart';
import 'package:gaay/service/api.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authController = ChangeNotifierProvider.autoDispose<AuthController>(
    (ref) => AuthController());

class AuthController extends ChangeNotifier {
  bool isLogin = false;
  bool isOtp = false;
  String mobileNumber = "";
  String userRole = "FARMER";

  AuthController() {
    _initializeState();
  }

  Future<void> _initializeState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool("login") ?? false;
    userRole = prefs.getString("role") ?? "FARMER";
    notifyListeners();
  }

  Future<void> setLogin(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("login", value);
    isLogin = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context, String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = await apiCall(
      query:
          "query CodeLogin(\$code:String!){codeLogin (code:\$code){ id, role, name, contact }} ",
      variables: {"code": code},
      headers: {"content-type": "*/*"},
    );

    if (!data.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", data.message);
      return;
    }
    await prefs.setString("id", data.data["codeLogin"]["id"].toString());
    await prefs.setString("role", data.data["codeLogin"]["role"]);
    await prefs.setString("name", data.data["codeLogin"]["name"]);
    await prefs.setString(
        "contact", data.data["codeLogin"]["contact"].toString());
    userRole = data.data["codeLogin"]["role"];
    await setLogin(true);
    if (!context.mounted) return;

    notifyListeners();
  }

  Future<bool> sendotp(BuildContext context, String code) async {
    final data = await apiCall(
      query: "mutation SendOtp(\$code:String!){ sendOtp(code:\$code){ id }}",
      variables: {"code": code},
      headers: {"content-type": "*/*"},
    );

    if (!data.status) {
      if (!context.mounted) return false;
      erroralert(context, "Error", data.message);
      return false;
    }
    if (!context.mounted) return true;
    isOtp = true;
    mobileNumber = code;
    doneAlert(context, 160, "Successful", "OTP sent successfully");
    return true;
    // notifyListeners();
  }

  Future<void> verifyotp(BuildContext context, String code, String otp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = await apiCall(
      query:
          "mutation VerifyOtp(\$otpInput:OtpInput!){ verifyOtp(otpInput:\$otpInput){ id, role, name, contact }} ",
      variables: {
        "otpInput": {"code": code, "otp": otp}
      },
      headers: {"content-type": "*/*"},
    );
    if (!data.status) {
      if (!context.mounted) return;
      erroralert(context, "Error", data.message);
      return;
    }

    await prefs.setString("id", data.data["verifyOtp"]["id"].toString());
    await prefs.setString("role", data.data["verifyOtp"]["role"]);
    await prefs.setString("name", data.data["verifyOtp"]["name"]);
    await prefs.setString(
        "contact", data.data["verifyOtp"]["contact"].toString());
    userRole = data.data["verifyOtp"]["role"];
    await setLogin(true);
    if (!context.mounted) return;
    if (data.data["verifyOtp"]["role"] == "STOCKMEN") {
      context.replace("/addcow");
    } else if (data.data["verifyOtp"]["role"] == "SELLERCOW") {
      context.replace("/sellercow");
    } else if (data.data["verifyOtp"]["role"] == "SELLERMEDICINE") {
      context.replace("/sellermedicine");
    } else if (data.data["verifyOtp"]["role"] == "SELLERFODDER") {
      context.replace("/sellerfood");
    } else if (data.data["verifyOtp"]["role"] == "DOCTOR") {
      context.replace("/doctorhome");
    } else {
      context.replace("/home");
    }
    notifyListeners();
  }
}

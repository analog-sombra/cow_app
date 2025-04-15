import 'package:flutter/cupertino.dart';
import 'package:gaay/components/bottombar.dart';
import 'package:gaay/components/cowbottombar.dart';
import 'package:gaay/components/foodbottombar.dart';
import 'package:gaay/components/medicinebottombar.dart';
import 'package:gaay/router/routername.dart';
import 'package:gaay/state/auth_controller.dart';
import 'package:gaay/view/doctor/cowhealthform.dart';
import 'package:gaay/view/doctor/cowtreatment.dart';
import 'package:gaay/view/doctor/doctorhome.dart';
import 'package:gaay/view/farmer/feedback.dart';
import 'package:gaay/view/farmer/help.dart';
import 'package:gaay/view/farmer/loan.dart';
import 'package:gaay/view/farmer/payment.dart';
import 'package:gaay/view/farmer/profile.dart';
import 'package:gaay/view/sellers/sellercow.dart';
import 'package:gaay/view/sellers/sellerfood.dart';
import 'package:gaay/view/sellers/sellermedicine.dart';
import 'package:gaay/view/stockman/add_cow.dart';
import 'package:gaay/view/farmer/details.dart';
import 'package:gaay/view/error404.dart';
import 'package:gaay/view/login.dart';
import 'package:gaay/view/stockman/editcow.dart';
import 'package:gaay/view/stockman/farmercows.dart';
import 'package:gaay/view/welcome.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authController);
  final GoRouter router = GoRouter(
    initialLocation: "/welcome",
    refreshListenable: authNotifier,
    redirect: (context, state) async {
      final bool isLogin = authNotifier.isLogin;
      final String role = authNotifier.userRole;

      // Prevent logged-in users from accessing login-related pages
      if (authNotifier.isOtp && !isLogin) {
        return "/welcome/login";
      }

      // Redirect logged-in users based on role
      if (isLogin) {
        if (state.matchedLocation == "/welcome") {
          // Role-based redirection
          if (role == "STOCKMEN") {
            return "/addcow";
          }
          if (role == "SELLERCOW") {
            return "/sellercow";
          }
          if (role == "SELLERMEDICINE") {
            return "/sellermedicine";
          }
          if (role == "SELLERFODDER") {
            return "/sellerfood";
          }
          if (role == "DOCTOR") {
            return "/doctorhome";
          }
          return "/home";
        }
      }

      // if (state.matchedLocation == "/welcome" && isLogin) {
      //   return "/home";
      // }
      if (!isLogin && state.matchedLocation == "/welcome/login") {
        return "/welcome/login";
      }

      // Prevent non-logged-in users from accessing protected pages
      if (!isLogin && state.matchedLocation != "/welcome") {
        return "/welcome";
      }

      return null;
    },
    errorBuilder: (BuildContext context, state) => const ErrorPage(),
    routes: [
      GoRoute(
        name: RouteNames.doctorhome,
        path: "/doctorhome",
        builder: (context, state) => DoctorHome(),
        routes: [
          GoRoute(
              name: RouteNames.cowtreatment,
              path: "cowtreatment/:id",
              builder: (context, state) => CowTreatment(
                    id: int.parse(
                      state.pathParameters["id"]!,
                    ),
                  ),
              routes: [
                GoRoute(
                  name: RouteNames.cowhealthform,
                  path: "cowhealthform",
                  builder: (context, state) => CowHealthForm(
                    id: int.parse(
                      state.pathParameters["id"]!,
                    ),
                  ),
                )
              ]),
        ],
      ),
      GoRoute(
        name: RouteNames.sellercow,
        path: "/sellercow",
        builder: (context, state) => CowCustomBottomNavBars(),
      ),
      GoRoute(
        name: RouteNames.sellermedicine,
        path: "/sellermedicine",
        builder: (context, state) => MedicineCustomBottomNavBars(),
      ),
      GoRoute(
        name: RouteNames.sellerfood,
        path: "/sellerfood",
        builder: (context, state) => FoodCustomBottomNavBars(),
      ),
      GoRoute(
          name: RouteNames.addcow,
          path: "/addcow",
          builder: (context, state) => AddCow(),
          routes: [
            GoRoute(
              name: RouteNames.farmercows,
              path: "farmercows/:id",
              builder: (context, state) => FarmerCows(
                id: int.parse(state.pathParameters["id"]!),
              ),
              routes: [],
            ),
            GoRoute(
              name: RouteNames.editcow,
              path: "editcow/:id",
              builder: (context, state) => EditCow(
                id: int.parse(state.pathParameters["id"]!),
              ),
              routes: [],
            ),
          ]),
      GoRoute(
          name: RouteNames.welcome,
          path: "/welcome",
          builder: (context, state) => WelcomePage(),
          routes: [
            GoRoute(
              name: RouteNames.login,
              path: "login",
              builder: (context, state) => LoginPage(),
            ),
          ]),
      GoRoute(
        name: RouteNames.home,
        path: "/home",
        builder: (context, state) => const CustomBottomNavBars(),
        routes: [
          GoRoute(
            name: RouteNames.details,
            path: "details/:id",
            builder: (context, state) => DetailsPage(
              id: int.parse(state.pathParameters["id"]!),
            ),
          ),
          GoRoute(
            name: RouteNames.loan,
            path: "loan",
            builder: (context, state) => LoanPage(),
          ),
          GoRoute(
            name: RouteNames.payment,
            path: "payment/:amount",
            builder: (context, state) => PaymentPage(
              amount: state.pathParameters["amount"]!,
            ),
          ),
          GoRoute(
            name: RouteNames.profile,
            path: "profile",
            builder: (context, state) => ProfilePage(),
          ),
          GoRoute(
            name: RouteNames.feedback,
            path: "feedback",
            builder: (context, state) => FeedBackPage(),
          ),
          GoRoute(
            name: RouteNames.help,
            path: "help",
            builder: (context, state) => HelpPage(),
          ),
        ],
      ),
    ],
  );
  return router;
});

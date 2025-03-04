import 'package:flutter/cupertino.dart';
import 'package:gaay/components/bottombar.dart';
import 'package:gaay/router/routername.dart';
import 'package:gaay/state/auth_controller.dart';
import 'package:gaay/view/farmer/feedback.dart';
import 'package:gaay/view/farmer/loan.dart';
import 'package:gaay/view/farmer/payment.dart';
import 'package:gaay/view/farmer/profile.dart';
import 'package:gaay/view/stockman/add_cow.dart';
import 'package:gaay/view/farmer/details.dart';
import 'package:gaay/view/error404.dart';
import 'package:gaay/view/login.dart';
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
        name: RouteNames.addcow,
        path: "/addcow",
        builder: (context, state) => AddCow(),
      ),
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
        ],
      ),
    ],
  );
  return router;
});

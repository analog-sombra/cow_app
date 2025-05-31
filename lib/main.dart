import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gaay/router/router.dart';
import 'package:gaay/state/connection.dart';
import 'package:gaay/utils/state_logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      observers: [StateLogger()],
      child: CowApp(),
    ),
  );
}

class CowApp extends HookConsumerWidget {
  const CowApp({super.key});

  // Move the key outside the build method
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(connectivityStatusProviders, (previous, next) {
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            next == ConnectivityResult.none
                ? 'Disconnected from Internet'
                : 'Connected to Internet',
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor:
              next == ConnectivityResult.none ? Colors.red : Colors.green,
        ),
      );
    });

    final goRouter = ref.watch(goRouterProvider);
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: MaterialApp.router(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'GB'), // English, UK
          Locale('ar', 'AE'), // Arabic, UAE
          Locale('en', 'IN'), // English, India
        ],
        scaffoldMessengerKey: scaffoldMessengerKey, // Use the static key
        title: 'GAAY',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00BFA6),
          ),
          useMaterial3: true,
        ),
        routerConfig: goRouter,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

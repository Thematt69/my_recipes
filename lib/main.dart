import 'dart:async';
import 'dart:isolate';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/blocs/bloc_provider.dart';
import 'package:my_recipes/blocs/store_bloc.dart';
import 'package:my_recipes/firebase_options.dart';

void main() {
  final logger = Logger();
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      if (!kIsWeb) {
        PlatformDispatcher.instance.onError = (error, stack) {
          logger.e('🛑 ERREUR NON CAPTURÉ 🛑', error: error, stackTrace: stack);
          return true;
        };

        Isolate.current.addErrorListener(
          RawReceivePort((List<dynamic> errorAndStacktrace) async {
            final error = errorAndStacktrace.firstOrNull;
            final stack = errorAndStacktrace.last as StackTrace?;
            logger.e(
              '🛑 ERREUR NON CAPTURÉ 🛑',
              error: error,
              stackTrace: stack,
            );
          }).sendPort,
        );
      }

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await FirebaseAuth.instance.signInAnonymously();

      runApp(const MyApp());
    },
    (error, stack) =>
        logger.e('🛑 ERREUR NON CAPTURÉ 🛑', error: error, stackTrace: stack),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: GlobalKey(),
      blocs: [
        StoreBloc(),
      ],
      child: DynamicColorBuilder(
        builder: (lightDynamicColorScheme, darkDynamicColorScheme) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Mes recettes',
            theme: ThemeData(
              colorScheme: lightDynamicColorScheme ??
                  ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            darkTheme: ThemeData(
              colorScheme: darkDynamicColorScheme ??
                  ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
            routeInformationProvider: goRouter.routeInformationProvider,
          );
        },
      ),
    );
  }
}

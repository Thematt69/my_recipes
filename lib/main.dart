import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_apps/themes/theme_data.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/blocs/bloc_provider.dart';
import 'package:my_recipes/blocs/firebase_auth_bloc.dart';
import 'package:my_recipes/blocs/store_bloc.dart';
import 'package:my_recipes/default_firebase_options.dart';
import 'package:my_recipes/extensions/exception.dart';
import 'package:my_recipes/fridge_firebase_options.dart';

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      if (!kIsWeb) {
        PlatformDispatcher.instance.onError = (error, stack) {
          error.logException();
          return true;
        };

        Isolate.current.addErrorListener(
          RawReceivePort((List<dynamic> errorAndStacktrace) async {
            (errorAndStacktrace.firstOrNull as Object).logException();
          }).sendPort,
        );
      }

      await initializeDateFormatting('fr_FR');

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await Firebase.initializeApp(
        name: FridgeFirebaseOptions.name,
        options: FridgeFirebaseOptions.currentPlatform,
      );

      FlutterNativeSplash.remove();

      runApp(const MyApp());
    },
    (error, stackTrace) => error.logException(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: GlobalKey(),
      blocs: [
        FirebaseAuthBloc(),
        StoreBloc(),
      ],
      child: MaterialApp.router(
        restorationScopeId: 'fr.thematt69.my_recipes',
        title: 'Mes recettes',
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        routeInformationParser: goRouter.routeInformationParser,
        routerDelegate: goRouter.routerDelegate,
        routeInformationProvider: goRouter.routeInformationProvider,
      ),
    );
  }
}

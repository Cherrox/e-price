import 'package:e_price/src/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  Intl.defaultLocale = 'es';
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  final userBox = await Hive.openBox('user');
  final isLoggedIn = userBox.get('isLoggedIn', defaultValue: false);
  // Inicializar la caja de Hive
  await LocalStorage.configureBox();
  //bloquear orientacion de la pantalla
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => AuthProviderP()),
        ChangeNotifierProvider(lazy: false, create: (_) => LoginProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => RegisterProvider()),
      ],
      child: MaterialApp(
        // navigatorKey: NavigationServices.navigatorKey,
        navigatorObservers: [OrientationResetObserver()],
        scaffoldMessengerKey: NotificationService.messengerKey,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('es', 'ES'),
        ],
        debugShowCheckedModeBanner: false,

        initialRoute: Routes.login,
        routes: appRoutes,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/theme_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/drawing_provider.dart';
import 'providers/gallery_provider.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';
import 'utils/app_colors.dart';
import 'l10n/app_localizations.dart';
import 'services/ad_service.dart';
import 'widgets/interstitial_ad_service.dart';

// RouteObserver global para controlar visibilidade das telas
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive para persistência local
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('progress');
  await Hive.openBox('gallery');
  
  // Inicializar AdMob
  await AdService.initialize();
  
  // Carregar intersticiais
  await InterstitialAdService.loadAd();
  
  // Manter orientação vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const ColorindoComDeusApp());
}

class ColorindoComDeusApp extends StatelessWidget {
  const ColorindoComDeusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => DrawingProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
      ],
      child: Consumer2<ThemeProvider, SettingsProvider>(
        builder: (context, themeProvider, settingsProvider, _) {
          return MaterialApp(
            title: 'Colorindo com Deus',
            debugShowCheckedModeBanner: false,
            
            // RouteObserver para controlar visibilidade das telas
            navigatorObservers: [routeObserver],
            
            // Tema
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
              ),
              fontFamily: 'ComicNeue',
              scaffoldBackgroundColor: AppColors.background,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.dark,
              ),
              fontFamily: 'ComicNeue',
            ),
            themeMode: themeProvider.themeMode,
            
            // Internacionalização
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('pt', 'BR'),
              Locale('en', 'US'),
              Locale('es', 'ES'),
            ],
            locale: settingsProvider.currentLocale,
            
            // Rotas
            initialRoute: '/loading',
            routes: {
              '/loading': (context) => const LoadingScreen(),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}


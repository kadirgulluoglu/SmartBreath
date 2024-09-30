import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbreath/new_lib/core/constants/shared_prefs_keys.dart';
import 'package:smartbreath/new_lib/core/services/navigation_service.dart';
import 'package:smartbreath/new_lib/core/viewmodels/auth_view_model.dart';
import 'package:smartbreath/new_lib/core/viewmodels/theme_view_model.dart';
import 'package:smartbreath/new_lib/ui/views/home_view.dart';
import 'package:smartbreath/new_lib/ui/views/onboarding_view.dart';
import 'package:smartbreath/new_lib/ui/views/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['tr', 'en']);
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  
  bool rememberMe = prefs.getBool(SharedPrefsKeys.rememberMe) ?? false;
  bool showOnboarding = prefs.getBool(SharedPrefsKeys.showOnboarding) ?? true;
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MyApp(
        prefs: prefs,
        rememberMe: rememberMe,
        showOnboarding: showOnboarding,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final bool rememberMe;
  final bool showOnboarding;

  const MyApp({
    Key? key,
    required this.prefs,
    required this.rememberMe,
    required this.showOnboarding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeViewModel, _) {
        return LocaleBuilder(
          builder: (locale) => MaterialApp(
            localizationsDelegates: Locales.delegates,
            supportedLocales: Locales.supportedLocales,
            locale: locale,
            title: "SmartBreath",
            themeMode: themeViewModel.themeMode,
            theme: themeViewModel.lightTheme,
            darkTheme: themeViewModel.darkTheme,
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.navigatorKey,
            home: _getInitialRoute(),
          ),
        );
      },
    );
  }

  Widget _getInitialRoute() {
    if (showOnboarding) {
      return OnboardingView();
    } else if (rememberMe) {
      return HomeView();
    } else {
      return LoginView();
    }
  }
}
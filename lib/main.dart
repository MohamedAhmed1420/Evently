import 'package:evently/modules/layout/screens/desc_screen.dart';
import 'package:evently/modules/start/screens/IntroScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'core/app_provider/app_provider.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'modules/add_event/screens/add_event_screen.dart';
import 'modules/auth/screens/forget_password_screen.dart';
import 'modules/auth/screens/login_screen.dart';
import 'modules/auth/screens/resgister_screen.dart';
import 'modules/edit_eventl_screen/screen/edit_event.dart';
import 'modules/layout/screens/layout_screen.dart';
import 'modules/splash/screens/splash_screen.dart';
import 'modules/start/screens/start_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GoogleSignIn.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      builder: (context, child) {
        var provider = Provider.of<AppProvider>(context);
        return MaterialApp(
          routes: {
            SplashScreen.routeName : (_) => SplashScreen(),
            StartScreen.routeName : (_) => StartScreen(),
            IntroScreen.routeName:(_)=>IntroScreen(),
            LoginScreen.routeName : (_) => LoginScreen(),
            RegisterScreen.routeName : (_) => RegisterScreen(),
            ForgetPasswordScreen.routeName : (_) => ForgetPasswordScreen(),
            LayoutScreen.routeName : (_) => LayoutScreen(),
            AddEventScreen.routeName : (_) => AddEventScreen(),
            DescScreen.routeName : (_) => DescScreen(),
            EditEvent.routeName : (_) => EditEvent(),

          },
          initialRoute:SplashScreen.routeName,
          locale: Locale(provider.locale),
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            ...GlobalMaterialLocalizations.delegates,
          ],          supportedLocales: [
            Locale('en'), // English
            Locale('ar'), // Arabic
          ],
          themeMode: provider.themeMode,
          // light theme
          theme: AppTheme.lightTheme,
          // dark theme
          darkTheme: AppTheme.darkTheme,
          title: 'Flutter Demo',
        );
      },
    );
  }
}

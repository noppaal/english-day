import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/auth/auth_screens.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const EnglishDayApp());
}

class EnglishDayApp extends StatelessWidget {
  const EnglishDayApp({super.key, this.home});

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Day',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: home ?? const SplashScreen(),
    );
  }
}

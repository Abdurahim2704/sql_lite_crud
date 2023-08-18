import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:sql_lite_crud/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPlatformDark =
        View.of(context).platformDispatcher.platformBrightness ==
            Brightness.dark;
    final initTheme = isPlatformDark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    return ThemeProvider(
      initTheme: initTheme,
      builder: (_, myTheme) {
        return MaterialApp(
          theme: myTheme,
          home: const HomePageController(),
        );
      },
    );
  }
}

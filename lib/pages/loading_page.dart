import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App1"),
        leading: ThemeSwitcher.withTheme(
          builder: (_, switcher, theme) {
            return IconButton(
              splashRadius: 1,
              onPressed: () => switcher.changeTheme(
                theme: theme.brightness == Brightness.light
                    ? ThemeData.dark(useMaterial3: true)
                    : ThemeData.light(useMaterial3: true),
              ),
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? CupertinoIcons.moon_fill
                    : CupertinoIcons.sun_max_fill,
                size: 30,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.yellow,
              ),
            );
          },
        ),
      ),
      body: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeThemeIcon extends StatelessWidget {
  const ChangeThemeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Theme.of(context).brightness == Brightness.dark
          ? CupertinoIcons.moon_fill
          : CupertinoIcons.sun_max_fill,
      size: 30,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.yellow,
    );
  }
}

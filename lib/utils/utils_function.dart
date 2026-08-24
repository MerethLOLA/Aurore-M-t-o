import 'package:flutter/material.dart';
import 'package:meteo/screens/home_screen.dart';

class UtilsFunction {
  static void navigation(BuildContext context, Widget destination) {
    if (destination is HomeScreen) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => destination),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (context) => destination),
      );
    }
  }

  static void redirectAfterDelay(BuildContext context, Widget destination) {
    Future.delayed(const Duration(seconds: 2), () {
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    });
  }
}

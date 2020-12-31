import 'package:flutter/material.dart';

class Transition {
  static Route handleNavigationPressed(Widget nextWindow) {
    return PageRouteBuilder(
      transitionDuration: const Duration(
        milliseconds: 700,
      ),
      pageBuilder: (context, animation, secondaryAnimation) => nextWindow,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

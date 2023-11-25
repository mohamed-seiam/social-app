import 'package:flutter/material.dart';
class SizeTransition4 extends PageRouteBuilder {
  final Widget page;

  SizeTransition4(this.page) : super(
      pageBuilder: (context, animation, anotherAnimation) => page,
      transitionDuration: const Duration(milliseconds: 1000),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, anotherAnimation, child) {
        animation = CurvedAnimation(parent: animation,
            curve: Curves.fastLinearToSlowEaseIn,
            reverseCurve: Curves.fastOutSlowIn);
        return Align(
          alignment: Alignment.centerLeft,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: 0,
            axis: Axis.horizontal,
            child: page,
          ),
        );
      }
  );
}
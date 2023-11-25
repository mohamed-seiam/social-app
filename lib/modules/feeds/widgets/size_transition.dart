import 'package:flutter/material.dart';

class SizeTransition1 extends PageRouteBuilder {
  final Widget page;

  SizeTransition1(this.page) : super(
      pageBuilder: (context, animation, anotherAnimation) => page,
      transitionDuration: const Duration(milliseconds: 2000),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, anotherAnimation, child) {
        animation = CurvedAnimation(parent: animation,
            curve: Curves.fastLinearToSlowEaseIn,
            reverseCurve: Curves.fastOutSlowIn);
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: 0,
            child: page,
          ),
        );
      }
  );
}
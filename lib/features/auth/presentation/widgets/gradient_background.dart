import 'dart:ui';

import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gradient nền chính
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(59, 21, 120, 0.8),
                  Color.fromRGBO(81, 114, 179, 1),
                  Color.fromRGBO(255, 83, 192, 1),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Hình tròn mờ bên trái
          Positioned(
            top: 0,
            left: -100,
            child: Container(
              width: 300,
              height: 450,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300), // oval
                color: Colors.transparent,
                // border: Border.all(color: Colors.black), // debug
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(96, 255, 202, 0.4),
                    blurRadius: 200, // độ loang
                    spreadRadius: 50, // độ lan
                  ),
                ],
              ),
            ),
          ),

          // Hình tròn mờ bên phải
          Positioned(
            bottom: 0,
            right: -100,
            child: Container(
              width: 300,
              height: 450,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300), // oval
                color: Colors.transparent,
                // border: Border.all(color: Colors.black), //debug
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(255, 83, 202, 0.4),
                    blurRadius: 200, // độ loang
                    spreadRadius: 50, // độ lan
                  ),
                ],
              ),
            ),
          ),

          // Nội dung app
          child,
        ],
      ),
    );
  }
}

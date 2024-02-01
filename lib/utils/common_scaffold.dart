import 'package:flutter/material.dart';
import 'package:weather_app/utils/constants.dart';

class CommonScaffold extends StatelessWidget {
  const CommonScaffold({
    super.key,
    this.appBar,
    required this.isShowGradient,
    required this.child,
  });

  final Widget? appBar;
  final bool isShowGradient;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CommonGradient(
          isShowGradient: isShowGradient,
          child: child,
        ),
      ),
    );
  }
}

class CommonGradient extends StatelessWidget {
  const CommonGradient({
    super.key,
    required this.isShowGradient,
    required this.child,
  });

  final bool isShowGradient;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: isShowGradient == true ? null : Colors.white,
      decoration: isShowGradient == false
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.teal,
                  const Color(ColorConsts.bannerColor).withOpacity(0.8),
                  Colors.brown,
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

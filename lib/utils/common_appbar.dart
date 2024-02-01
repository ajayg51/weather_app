import 'package:flutter/material.dart';
import 'package:ridiv_assignment/utils/assets.dart';

class CommonAppbar extends StatelessWidget {
  const CommonAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.weatherBanner,
      fit: BoxFit.cover,
    );
  }
}

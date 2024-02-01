import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridiv_assignment/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            bodyMedium: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            bodySmall: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          )),
      home: SplashScreen(),
      // home: HomeScreen(
      //   isLocationPermissionEnabled: true,
      //   place: Placemark(),
      //   lat: 0,
      //   longtd: 0,
      // ),
    );
  }
}

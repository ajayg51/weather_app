import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/services/geo_location_service.dart';
import 'package:weather_app/utils/constants.dart';

class SplashScreenController extends GetxController {
  Position? position;
  bool isAllWell = false;
  @override
  void onReady() async {
    super.onReady();

    Get.showSnackbar(
      GetSnackBar(
        title: "Please be patient, getting location info",
        message: "Beware! app will quit on error",
        backgroundColor: Colors.green.withOpacity(0.5),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: const Color(ColorConsts.tealVariant),
      ),
    );

    await GeoLocation.getDeviceLocation().then((value) {
      isAllWell = true;
      position = value;
    }).onError((error, stackTrace) {
      exitApp(
        msg: "Exiting for now",
        desc: "Please allow location services",
      );
      return Future.error(error ?? "Can't get device location");
    });

    if (isAllWell && position != null) {
      Get.closeCurrentSnackbar();
      Get.off(HomeScreen(position: position!));
    }
  }

  void exitApp({
    required String msg,
    required String desc,
  }) {
    Get.defaultDialog(
      title: msg,
      middleText: desc,
      backgroundColor: Colors.orange.withOpacity(0.5),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      SystemNavigator.pop();
    });
  }
}

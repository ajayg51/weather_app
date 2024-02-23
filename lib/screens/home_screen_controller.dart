import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/models/place_weather_response.dart';
import 'package:weather_app/services/city_search_service.dart';
import 'package:weather_app/utils/country_enum.dart';

class HomeScreenController extends GetxController {
  HomeScreenController({required this.position});
  final Position position;

  final searchBoxSelectedFlag = Country.india.obs;
  final selectedFlag = Country.india.obs;
  final curLocFlag = Country.none.obs;

  final citySearchController = TextEditingController();
  CitySearchService citySearchService = CitySearchService();

  final curLocWeatherResponse = PlaceWeatherResponse.empty().obs;
  final placeWeatherResponse = PlaceWeatherResponse.empty().obs;

  String searchedText = "";
  final isShowSearchedPlaceTile = true.obs;
  final isCurrentLocDataLoading = true.obs;
  final isSearchedPlaceDataLoading = true.obs;
  final isAbleToLoadCountryFlag = true.obs;

  @override
  void onReady() {
    super.onReady();
    getWeatherData(
      isFetchCurrentLocData: true,
      lat: position.latitude,
      lon: position.longitude,
    );
  }

  void onSelectFlag({required Country flag}) {
    if (flag == searchBoxSelectedFlag.value) {
      Get.back(closeOverlays: true);
      return;
    }
    searchBoxSelectedFlag.value = flag;
    Get.back(closeOverlays: true);
    citySearchController.clear();
  }

  void onSearchIconTap() async {
    final place = citySearchController.text.trim();
    if (place.isEmpty || place == searchedText) return;
    searchedText = place;

    Get.focusScope?.unfocus();

    closeGetDialog();
    showGetDialog(
      title: "Fetching Data",
    );

    final latLongtdData = await citySearchService.getLatLongtdForPlace(
      place: place,
      countryCode: Country.india.getISOCountryCodes,
    );

    if (latLongtdData != null && latLongtdData.list.isNotEmpty) {
      getWeatherData(
        lat: latLongtdData.list[0].lat,
        lon: latLongtdData.list[0].lon,
      );

      selectedFlag.value = searchBoxSelectedFlag.value;
    } else {
      isShowSearchedPlaceTile.value = false;
      closeGetDialog();
      showGetDialog(
        title: "Failure!",
        info: "Oh ho! something went wrong",
        isShowProgress: false,
      );
      closeGetDialog(milliseconds: 1000);
    }
  }

  void getWeatherData({
    bool? isFetchCurrentLocData,
    required double lat,
    required double lon,
  }) async {
    final weatherData = await citySearchService.getPlaceWeatherBasisLatAndLong(
      lat: lat,
      lon: lon,
    );
    closeGetDialog(milliseconds: 1000);

    if (weatherData != null) {
      if (isFetchCurrentLocData == true) {
        isCurrentLocDataLoading.toggle();
        final String countryCode = weatherData.sys?.country ?? "";
        curLocFlag.value = countryCode.getCountryEnumFromString;
        curLocWeatherResponse.value = weatherData;
      } else {
        isSearchedPlaceDataLoading.toggle();
      }
      closeGetDialog();
      showGetDialog(
        title: "Success!",
        info: "Api call status :  SUCCESS",
        isShowProgress: false,
      );
      await Future.delayed(const Duration(milliseconds: 1000));
      closeGetDialog();
      placeWeatherResponse.value = weatherData;
      isShowSearchedPlaceTile.value = true;
    } else {
      isShowSearchedPlaceTile.value = false;
      closeGetDialog();
      showGetDialog(
        title: "Failure!",
        info: "Oh ho! something went wrong",
        isShowProgress: false,
      );
      closeGetDialog(milliseconds: 1000);
    }
  }

  void showGetDialog({
    required String title,
    String? info,
    bool? isShowProgress,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: Get.textTheme.bodyLarge?.copyWith(
        color: Colors.white,
      ),
      middleText: isShowProgress == false ? info ?? "" : "",
      middleTextStyle: Get.textTheme.bodyLarge?.copyWith(
        color: Colors.white,
        fontSize: 16,
      ),
      backgroundColor: Colors.orange.withOpacity(0.5),
      content: isShowProgress == false
          ? null
          : const CircularProgressIndicator(
              color: Colors.black,
            ),
    );
  }

  void closeGetDialog({int? milliseconds}) async {
    await Future.delayed(Duration(milliseconds: milliseconds ?? 500));
    Get.back(closeOverlays: true);
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/models/place_weather_response.dart';
import 'package:weather_app/screens/home_screen_controller.dart';
import 'package:weather_app/utils/common_appbar.dart';
import 'package:weather_app/utils/common_scaffold.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/country_enum.dart';
import 'package:weather_app/utils/extensions.dart';
import 'package:weather_app/utils/separator.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    super.key,
    required Position position,
  }) {
    controller = Get.put(HomeScreenController(position: position));
  }
  late final HomeScreenController controller;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      isShowGradient: true,
      child: Column(
        children: [
          const CommonAppbar(),
          10.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(() {
                    final data = controller.curLocWeatherResponse.value;
                    final isLoading = controller.isCurrentLocDataLoading.value;
                    final flag = controller.curLocFlag.value;
                    if (isLoading) {
                      return showAlertDialog;
                    }
                    return locationWeatherInfo(
                      data: data,
                      flag: flag,
                    ).padSymmetric(
                      horizontalPad: 12,
                    );
                  }),
                  12.verticalSpace,
                  const Separator(),
                  36.verticalSpace,
                  flagSearchCityBox.padSymmetric(horizontalPad: 12),
                  24.verticalSpace,
                  Obx(() {
                    final data = controller.placeWeatherResponse.value;
                    final flag = controller.selectedFlag.value;
                    final isLoading = controller.isCurrentLocDataLoading.value;
                    final isShowTile = controller.isShowSearchedPlaceTile.value;
                    if (isLoading) {
                      return showAlertDialog;
                    }
                    return locationWeatherInfo(
                      data: data,
                      flag: flag,
                      isShowNoDataTile: !isShowTile,
                    ).padSymmetric(
                      horizontalPad: 12,
                    );
                  }),
                  12.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get showAlertDialog {
    return AlertDialog(
      title: const Text(
        "Fetching data",
      ),
      backgroundColor: Colors.white.withOpacity(0.5),
      content: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.black,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget locationWeatherInfo({
    PlaceWeatherResponse? data,
    Country? flag,
    bool? isShowNoDataTile,
  }) {
    if (isShowNoDataTile == true) {
      return boilerPlateTile(
        child: Center(
          child: Text(
            "No data",
            style: Get.textTheme.bodyLarge,
          ),
        ),
      );
    }

    final countryCode = data?.sys?.country ?? "err";
    final double temperature = data?.main?.temp ?? 0;

    return boilerPlateTile(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all()),
                child: ClipOval(
                  child: Image.asset(
                    flag?.getAssetPath ?? Country.india.getAssetPath,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return Text("Code : $countryCode").padAll(value: 5);
                    },
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  "Current weather details",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Get.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          6.verticalSpace,
          const Separator(
            color: Colors.black,
          ),
          12.verticalSpace,
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                labelInfo(
                  label: "Weather condition : ",
                  info: data != null && data.weather.isNotEmpty
                      ? data.weather[0].description
                      : "will update",
                ),
                12.verticalSpace,
                labelInfo(
                  label: "Temperature : ",
                  info: data != null
                      ? "${temperature >= 273.16 ? (temperature - 273.16).toInt() : 0} \u2103"
                      : "will update",
                ),
                12.verticalSpace,
                labelInfo(
                  label: "Location : ",
                  info: data != null ? data.name : "will update",
                ),
              ],
            ).padAll(value: 10),
          ),
        ],
      ).padSymmetric(horizontalPad: 12),
    );
  }

  Widget labelInfo({
    required String label,
    required String info,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Text(
            info.capitalizeFirst ?? "Error",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget get flagSearchCityBox {
    return boilerPlateTile(
      child: Column(
        children: [
          selectFlag,
          12.verticalSpace,
          Row(
            children: [
              Expanded(child: searchCityBox),
            ],
          ),
        ],
      ).padSymmetric(
        horizontalPad: 12,
        verticalPad: 6,
      ),
    );
  }

  Widget get selectFlag {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          backgroundColor:
              const Color(ColorConsts.tealVariant).withOpacity(0.6),
          buildBottomSheetContent.padSymmetric(
            horizontalPad: 12,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Obx(() {
              final flagAsset = controller.selectedFlag.value.getAssetPath;
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ClipOval(
                  child: Image.asset(
                    flagAsset,
                    fit: BoxFit.contain,
                    width: 45,
                    height: 45,
                  ),
                ).padAll(value: 10),
              );
            }),
            2.horizontalSpace,
            const Icon(
              Icons.arrow_drop_down_outlined,
              size: 20,
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                "Please select country",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: const Color(ColorConsts.bannerColor),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ).padAll(value: 10),
      ),
    );
  }

  Widget get buildBottomSheetContent {
    final flagList = Country.values.toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          12.verticalSpace,
          ...List.generate(
            flagList.length - 1,
            (index) {
              final flag = flagList[index];

              return Column(
                children: [
                  InkWell(
                    onTap: () => controller.onSelectFlag(flag: flag),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              flag.getAssetPath,
                              width: 40,
                              height: 40,
                            ),
                          ).padAll(value: 10),
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Text(
                            flag.getCountryName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Get.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  12.verticalSpace,
                  const Separator(),
                  12.verticalSpace,
                ],
              );
            },
          ),
          60.verticalSpace,
        ],
      ),
    );
  }

  Widget get searchCityBox {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.citySearchController,
              decoration: const InputDecoration(hintText: "Search city name"),
            ).padSymmetric(horizontalPad: 12, verticalPad: 12),
          ),
          6.horizontalSpace,
          InkWell(
            onTap: controller.onSearchIconTap,
            child: const Icon(
              Icons.search,
              size: 30,
            ),
          ),
        ],
      ),
    ).padSymmetric(verticalPad: 12);
  }

  Widget boilerPlateTile({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(),
        color: Colors.white.withOpacity(0.2),
      ),
      child: child.padAll(value: 12),
    );
  }
}

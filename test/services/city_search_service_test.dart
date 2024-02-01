import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:ridiv_assignment/models/place_weather_response.dart';
import 'package:ridiv_assignment/services/city_search_service.dart';

void main() {
  final citySearchService = CitySearchService();
  

  group('City search service : ', () {
    group('Get location weather basis latitude and longitude : ', () {
      // arrange, as to what should happen

      when(
        () => citySearchService.getPlaceWeatherBasisLatAndLong(
          lat: -33.8688,
          lon: 151.2093,
        ),
      ).thenAnswer(
        (invocation) async {
          return PlaceWeatherResponse.empty();
        },
      );

      // act, actual call
      final data = citySearchService.getPlaceWeatherBasisLatAndLong(
        lat: -33.8688,
        lon: 151.2093,
      );

      // assert, result
      expect(data, isA<PlaceWeatherResponse>());
    });
  });

  // testWidgets('city search service ...', (tester) async {

  // });
}

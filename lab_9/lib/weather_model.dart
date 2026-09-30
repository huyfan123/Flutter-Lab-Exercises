import 'package:lab_9/location.dart';
import 'package:lab_9/networking.dart';

class WeatherModel {
  Future<dynamic> getCityWeather(String query) async {
    NetworkHelper networkHelper = NetworkHelper();
    var weatherData = await networkHelper.fetchWeather(query);
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    if (location.latitude == null || location.longitude == null) {
      return null;
    }

    String query = '${location.latitude},${location.longitude}';
    NetworkHelper networkHelper = NetworkHelper();
    var weatherData = await networkHelper.fetchWeather(query);
    return weatherData;
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    NetworkHelper networkHelper = NetworkHelper();
    var results = await networkHelper.fetchSearchSuggestions(query);
    
    List<String> suggestions = [];
    for (var result in results) {
      suggestions.add('${result['name']}, ${result['country']}');
    }
    return suggestions;
  }
}

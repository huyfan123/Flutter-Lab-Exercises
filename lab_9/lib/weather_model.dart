import 'package:lab_9/location.dart';
import 'package:lab_9/networking.dart';

const apiKey = '6cdeb751bfa7ac9150e827cc5fea7fb1'; // Please replace with your actual API key
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
      '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric',
    );

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    if (location.latitude == null || location.longitude == null) {
      return null;
    }

    NetworkHelper networkHelper = NetworkHelper(
      '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric',
    );

    var weatherData = await networkHelper.getData();
    return weatherData;
  }
}

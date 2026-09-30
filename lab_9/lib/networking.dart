import 'package:http/http.dart' as http;

import 'dart:convert';

const String apiKey =
    '4a5ed5a91b184df4b7275007263009'; // Please replace with actual API key
const String baseUrl = 'https://api.weatherapi.com/v1';

class NetworkHelper {
  Future<dynamic> fetchWeather(String query) async {
    final url = '$baseUrl/forecast.json?key=$apiKey&q=$query&days=1';
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print('Error fetching weather: ${response.statusCode}');
      return null;
    }
  }

  Future<List<dynamic>> fetchSearchSuggestions(String query) async {
    if (query.isEmpty) return [];

    final url = '$baseUrl/search.json?key=$apiKey&q=$query';
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print('Error fetching search suggestions: ${response.statusCode}');
      return [];
    }
  }
}

import 'package:flutter/material.dart';
import 'package:lab_9/weather_model.dart';
import 'package:intl/intl.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, this.locationWeather});

  final dynamic locationWeather;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  
  // Weather data variables
  int temperature = 0;
  String weatherIconUrl = '';
  String cityName = '';
  String description = '';
  String country = '';
  int humidity = 0;
  double windSpeed = 0.0;
  int minTemp = 0;
  int maxTemp = 0;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIconUrl = '';
        description = 'Unable to get weather data';
        cityName = '';
        country = '';
        humidity = 0;
        windSpeed = 0.0;
        minTemp = 0;
        maxTemp = 0;
        return;
      }

      var current = weatherData['current'];
      var location = weatherData['location'];
      var forecastDay = weatherData['forecast']['forecastday'][0]['day'];

      temperature = (current['temp_c'] as num).round();
      description = current['condition']['text'];
      
      String iconUrl = current['condition']['icon'];
      if (iconUrl.startsWith('//')) {
        iconUrl = 'https:$iconUrl';
      }
      weatherIconUrl = iconUrl;
      
      cityName = location['name'];
      country = location['country'];
      
      humidity = current['humidity'];
      windSpeed = (current['wind_kph'] as num).toDouble();
      
      minTemp = (forecastDay['mintemp_c'] as num).round();
      maxTemp = (forecastDay['maxtemp_c'] as num).round();
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Weather App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) async {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          try {
                            return await weather.getSearchSuggestions(textEditingValue.text);
                          } catch (e) {
                            return const Iterable<String>.empty();
                          }
                        },
                        onSelected: (String selection) async {
                          // Selection is "City, Country"
                          var weatherData = await weather.getCityWeather(selection);
                          updateUI(weatherData);
                        },
                        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            onEditingComplete: onEditingComplete,
                            decoration: InputDecoration(
                              hintText: 'Enter city name (e.g., Hanoi)',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Normally the button would search the current text,
                        // but with Autocomplete, selecting from dropdown is preferred.
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3498DB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.white, size: 18),
                          SizedBox(width: 5),
                          Text('Search', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (cityName.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF3498DB)),
                      const SizedBox(width: 5),
                      Text(
                        '$cityName, $country',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$currentTime local time',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (weatherIconUrl.isNotEmpty)
                    Image.network(
                      weatherIconUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 80),
                    )
                  else 
                    const Icon(Icons.cloud, size: 100, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$temperature°C',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 40),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 2.5,
                    children: [
                      _buildInfoCard(Icons.water_drop, 'Humidity', '$humidity%', Colors.blue),
                      _buildInfoCard(Icons.air, 'Wind Speed', '$windSpeed kph', Colors.lightBlue),
                      _buildInfoCard(Icons.thermostat, 'Min Temp', '$minTemp°C', Colors.blue),
                      _buildInfoCard(Icons.thermostat, 'Max Temp', '$maxTemp°C', Colors.blue),
                    ],
                  ),
                ] else ...[
                  const Center(
                    child: Text('No Data. Please search for a city.'),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

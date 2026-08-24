import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../model/city_weather.dart';

class WeatherService {
  // Coordonnées fixes : Open-Meteo interroge par latitude/longitude,
  // pas par nom de ville, donc pas besoin de géocodage à chaque appel.
  static const Map<String, (double, double)> _cityCoords = {
    'Dakar': (14.6928, -17.4467),
    'Thiès': (14.7910, -16.9359),
    'Saint-Louis': (16.0179, -16.4896),
    'Ziguinchor': (12.5665, -16.2733),
    'Touba': (14.8500, -15.8833),
    'Kolda': (12.8833, -14.9500),
    'Matam': (15.6558, -13.2554),
    'Sédhiou': (12.7081, -15.5569),
    'Kédougou': (12.5556, -12.1747),
  };

  List<String> _villeAleatoire() {
    final shuffled = _cityCoords.keys.toList()..shuffle(Random());
    return shuffled.take(5).toList();
  }

  Future<List<CityWeather>> meteoVilleSync({
    required void Function(CityWeather city, int index) onCityLoaded,
  }) async {
    final cities = _villeAleatoire();
    final List<CityWeather> results = [];

    for (int i = 0; i < cities.length; i++) {
      try {
        final city = await _fetchCity(cities[i]).timeout(
          const Duration(seconds: 20),
        );
        results.add(city);
        onCityLoaded(city, i);
      } on TimeoutException {
        throw Exception('Temps dépassé pour ${cities[i]}. Vérifie ta connexion.');
      } catch (e) {
        throw Exception('Erreur pour ${cities[i]} : $e');
      }

      await Future.delayed(const Duration(milliseconds: 1500));
    }

    return results;
  }

  Future<CityWeather> _fetchCity(String city) async {
    final coords = _cityCoords[city]!;
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': coords.$1.toString(),
      'longitude': coords.$2.toString(),
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,'
          'pressure_msl,wind_speed_10m,weather_code',
      'daily': 'temperature_2m_max,temperature_2m_min',
      'wind_speed_unit': 'ms',
      'timezone': 'auto',
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return CityWeather.fromOpenMeteo(city, jsonDecode(response.body));
    }
    throw Exception('Statut ${response.statusCode} pour $city');
  }
}

import 'package:flutter/material.dart';

class CityWeather {
  final String city;
  final double temperature;
  final String condition;
  final double tempMax;
  final double tempMin;
  final double feelLike;
  final double pressure;
  final double windSpeed;
  final int humidity;
  final double lat;
  final double lon;
  final IconData weatherIcon;

  CityWeather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.tempMax,
    required this.tempMin,
    required this.feelLike,
    required this.pressure,
    required this.windSpeed,
    required this.humidity,
    required this.lat,
    required this.lon,
    required this.weatherIcon,
  });

  /// Construit un CityWeather à partir de la réponse de l'API Open-Meteo
  /// (https://open-meteo.com/), qui ne nécessite pas de clé API.
  factory CityWeather.fromOpenMeteo(String city, Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;
    final code = (current['weather_code'] as num).toInt();

    return CityWeather(
      city: city,
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).round(),
      pressure: (current['pressure_msl'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      condition: _conditionLabel(code),
      weatherIcon: _conditionIcon(code),
      lat: (json['latitude'] as num).toDouble(),
      lon: (json['longitude'] as num).toDouble(),
      tempMax: (daily['temperature_2m_max'][0] as num).toDouble(),
      tempMin: (daily['temperature_2m_min'][0] as num).toDouble(),
    );
  }

  // Codes météo WMO utilisés par Open-Meteo :
  // https://open-meteo.com/en/docs#weathervariables
  static String _conditionLabel(int code) {
    if (code == 0) return 'Ciel dégagé';
    if (code <= 2) return 'Peu nuageux';
    if (code == 3) return 'Couvert';
    if (code == 45 || code == 48) return 'Brouillard';
    if (code >= 51 && code <= 57) return 'Bruine';
    if (code >= 61 && code <= 67) return 'Pluie';
    if (code >= 71 && code <= 77) return 'Neige';
    if (code >= 80 && code <= 82) return 'Averses';
    if (code == 85 || code == 86) return 'Averses de neige';
    if (code >= 95) return 'Orage';
    return 'Variable';
  }

  static IconData _conditionIcon(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code <= 2) return Icons.wb_cloudy_rounded;
    if (code == 3) return Icons.cloud_rounded;
    if (code == 45 || code == 48) return Icons.cloud_queue_rounded;
    if (code >= 51 && code <= 57) return Icons.grain_rounded;
    if (code >= 61 && code <= 67 || code >= 80 && code <= 82) {
      return Icons.water_drop_rounded;
    }
    if (code >= 71 && code <= 77 || code == 85 || code == 86) {
      return Icons.ac_unit_rounded;
    }
    if (code >= 95) return Icons.thunderstorm_rounded;
    return Icons.cloud_rounded;
  }
}

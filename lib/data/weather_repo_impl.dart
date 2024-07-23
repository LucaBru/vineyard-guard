import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:vineyard_guard/domain/entity/weather.dart';
import 'package:vineyard_guard/domain/repository/weather_repo.dart';

class WeatherRepositoryImpl extends WeatherRepo {
  final latitude = 45.83, longitude = 12.4123;

  @override
  Future<List<Weather>> weatherSince(DateTime date) async {
    int daysSinceLastTreatment = _daysSince(date);

    if (daysSinceLastTreatment == 0) return [];

    var url = 'https://api.open-meteo.com/v1/forecast?';
    var params = {
      'latitude': '$latitude&',
      'longitude': '$longitude&',
      'daily': 'temperature_2m_max,temperature_2m_min,rain_sum&',
      'past_days': '$daysSinceLastTreatment&',
      'forecast_days': '0'
    };

    final response = await http.get(Uri.parse(url +
        params.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .reduce((a, b) => a + b)));

    return (response.statusCode == 200)
        ? _extractWeatherDays(
            (jsonDecode(response.body) as Map<String, dynamic>)['daily'])
        : [];
  }

  List<Weather> _extractWeatherDays(Map<String, dynamic> json) {
    List<DateTime> days = _toList(json['time'], DateFormat('yyyy-MM-dd').parse);

    List<double> maxTemperatures =
        _toList(json['temperature_2m_max'], double.parse);

    List<double> minTemperatures =
        _toList(json['temperature_2m_min'], double.parse);

    List<double> precipitations = _toList(json['rain_sum'], double.parse);

    return days.asMap().entries.map((entry) {
      int index = entry.key;

      return Weather(entry.value, maxTemperatures[index],
          minTemperatures[index], precipitations[index]);
    }).toList();
  }

  List<T> _toList<T>(dynamic d, T Function(String) converter) {
    return (d is List)
        ? d.map((element) => converter('$element')).toList()
        : [];
  }

  int _daysSince(DateTime date) =>
      ((DateTime.now().difference(date).inHours) / 24).floor();
}

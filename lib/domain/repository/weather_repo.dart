import 'package:vineyard_guard/domain/entity/weather.dart';

abstract class WeatherRepo {
  Future<List<Weather>> weatherSince(DateTime date);
}

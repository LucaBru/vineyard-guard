import 'dart:math';

import 'package:vineyard_guard/data/weather_repo_impl.dart';
import 'package:vineyard_guard/domain/entity/weather.dart';
import 'package:vineyard_guard/domain/repository/weather_repo.dart';
import 'package:vineyard_guard/domain/use_case/treatment_uc.dart';

class WeatherUseCase {
  final WeatherRepo _repo = WeatherRepositoryImpl();

  /// get weather statistics as maximum and minimum temperatures and rains since last treatment
  Future<List<Weather>> weatherSinceLastTreatment() async =>
      _repo.weatherSince((await TreatmentUseCase().treatments())
          .map((treatment) => treatment.date)
          .reduce((a, b) => a.isAfter(b) ? a : b));
}

import 'package:vineyard_guard/data/weather_repo_impl.dart';
import 'package:vineyard_guard/domain/entity/treatment.dart';
import 'package:vineyard_guard/domain/entity/weather.dart';
import 'package:vineyard_guard/domain/repository/weather_repo.dart';
import 'package:vineyard_guard/domain/use_case/treatment_uc.dart';

class WeatherUseCase {
  final WeatherRepo _repo = WeatherRepositoryImpl();

  /// get weather statistics as maximum and minimum temperatures and rains since last treatment
  Future<List<Weather>> weatherSinceLastTreatment() async {
    List<Treatment> t = await TreatmentUseCase().treatments();
    return _repo.weatherSince((t.isNotEmpty)
        ? t
            .map((treatment) => treatment.date)
            .reduce((a, b) => a.isAfter(b) ? a : b)
        : DateTime.now().subtract(const Duration(days: 14)));
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'generated/weather.g.dart';

@JsonSerializable()
class Weather {
  final DateTime day;
  final double maxTemperature;
  final double minTemperature;
  final double precipitation;

  Weather(
    this.day,
    this.maxTemperature,
    this.minTemperature,
    this.precipitation,
  );

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

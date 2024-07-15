import 'package:json_annotation/json_annotation.dart';

part 'generated/quantity.g.dart';

@JsonSerializable()
class Quantity {
  final double value;
  final UnitOfMeasure unit;

  Quantity(this.value, this.unit);

  /// creates Quantity starting from [json]
  factory Quantity.fromJson(Map<String, dynamic> json) =>
      _$QuantityFromJson(json);

  /// returns json map
  Map<String, dynamic> toJson() => _$QuantityToJson(this);
}

enum UnitOfMeasure { KG, LT }

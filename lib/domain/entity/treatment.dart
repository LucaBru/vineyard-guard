import 'package:json_annotation/json_annotation.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';

part 'generated/treatment.g.dart';

@JsonSerializable(explicitToJson: true)
class Treatment {
  final String? id;
  final DateTime date;
  final Map<String, Quantity> pesticides;

  /// returns the quantity of [pesticide] used in the treatment
  Quantity? quantity(String pesticide) => pesticides[pesticide];

  Treatment(
    this.date,
    this.pesticides,
  ) : id = null;

  /// creates Treatment starting from [json]
  factory Treatment.fromJson(Map<String, dynamic> json) =>
      _$TreatmentFromJson(json);

  /// returns json map
  Map<String, dynamic> toJson() => _$TreatmentToJson(this);
}

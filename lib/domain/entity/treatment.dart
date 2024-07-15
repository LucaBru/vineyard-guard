import 'package:json_annotation/json_annotation.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';
import 'package:uuid/uuid.dart';

part 'generated/treatment.g.dart';

@JsonSerializable(explicitToJson: true)
class Treatment {
  final String id;
  final DateTime date;
  final Map<String, Quantity> pesticides;

  /// returns the quantity of [pesticide] used in the treatment
  Quantity? quantity(String pesticide) => pesticides[pesticide];

  Treatment(
    this.id,
    this.date,
    this.pesticides,
  );

  Treatment.autogenerateId(
    this.date,
    this.pesticides,
  ) : id = const Uuid().v1();

  /// creates Treatment starting from [json]
  factory Treatment.fromJson(Map<String, dynamic> json) =>
      _$TreatmentFromJson(json);

  /// returns json map
  Map<String, dynamic> toJson() => _$TreatmentToJson(this);
}

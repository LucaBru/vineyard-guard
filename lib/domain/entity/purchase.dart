import 'package:json_annotation/json_annotation.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';

part 'generated/purchase.g.dart';

@JsonSerializable(explicitToJson: true)
class Purchase {
  final String? id;
  final String pesticide;
  final Quantity quantity;
  final double price;

  Purchase(this.pesticide, this.quantity, this.price) : id = null;

  /// creates Treatment starting from [json]
  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);

  /// returns json map
  Map<String, dynamic> toJson() => _$PurchaseToJson(this);
}

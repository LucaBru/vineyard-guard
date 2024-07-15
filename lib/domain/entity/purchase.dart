import 'package:vineyard_guard/domain/entity/quantity.dart';

class Purchase {
  final int id;
  final String pesticide;
  final Quantity quantity;
  final double price;

  Purchase(this.id, this.pesticide, this.quantity, this.price);
}

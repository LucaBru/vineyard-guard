import 'package:vineyard_guard/domain/shared_type.dart';

class Purchase {
  final int id;
  final Pesticide pesticide;
  final Quantity quantity;
  final double price;

  Purchase(this.id, this.pesticide, this.quantity, this.price);
}

import 'package:vineyard_guard/domain/entity/quantity.dart';

class StockedPesticide {
  final String pesticide;
  double purchased;
  double used;
  final UnitOfMeasure unit;

  StockedPesticide(
    this.pesticide,
    this.purchased,
    this.used,
    this.unit,
  );

  double get available => purchased - used;
}

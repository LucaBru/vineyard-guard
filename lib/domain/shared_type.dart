class Quantity {
  final double value;
  final UnitOfMeasure unit;

  Quantity(this.value, this.unit);
}

typedef Pesticide = String;

enum UnitOfMeasure { KG, LT }

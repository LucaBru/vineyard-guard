import 'package:vineyard_guard/domain/shared_type.dart';

class Treatment {
  final int id;
  final DateTime date;
  final Map<Pesticide, Quantity> pesticides;

  /// returns the quantity of [pesticide] used in the treatment
  Quantity? quantity(Pesticide pesticide) => pesticides[pesticide];

  Treatment(
    this.id,
    this.date,
    this.pesticides,
  );
}

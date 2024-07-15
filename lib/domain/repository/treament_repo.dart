import 'package:vineyard_guard/domain/entity/treatment.dart';

abstract class TreatmentRepo {
  Future<List<Treatment>> treatments();
  void add(Treatment t);
  void remove(Treatment t);
}

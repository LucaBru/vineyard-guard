import 'package:vineyard_guard/data/treatment_repo_impl.dart';
import 'package:vineyard_guard/domain/entity/treatment.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';
import 'package:vineyard_guard/domain/repository/treament_repo.dart';

class TreatmentUseCase {
  final TreatmentRepo _repo = TreatmentRepoImpl();

  Future<List<Treatment>> treatments() => _repo.treatments();
  void add(DateTime date, Map<String, Quantity> pesticides) =>
      _repo.add(Treatment(date, pesticides));
}

import 'package:vineyard_guard/data/treatment_repo_impl.dart';
import 'package:vineyard_guard/domain/entity/treatment.dart';
import 'package:vineyard_guard/domain/repository/treament_repo.dart';

class TreatmentUseCase {
  final TreatmentRepo _repo = TreatmentRepoImpl();

  Future<List<Treatment>> treatments() => _repo.treatments();

  void add(Treatment t) => _repo.add(t);

  void remove(String id) => _repo.remove(id);
}

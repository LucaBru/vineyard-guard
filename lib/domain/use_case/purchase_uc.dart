import 'package:vineyard_guard/data/purchase_repo_impl.dart';
import 'package:vineyard_guard/domain/entity/purchase.dart';
import 'package:vineyard_guard/domain/repository/purchase_repo.dart';

class PurchaseUseCase {
  final PurchaseRepo _repo = PurchaseRepoImpl();

  Future<List<Purchase>> purchases() => _repo.purchases();

  void add(Purchase p) => _repo.add(p);

  void remove(String id) => _repo.remove(id);
}

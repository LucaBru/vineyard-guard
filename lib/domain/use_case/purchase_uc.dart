import 'package:vineyard_guard/data/purchase_repo_impl.dart';
import 'package:vineyard_guard/domain/entity/purchase.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';
import 'package:vineyard_guard/domain/repository/purchase_repo.dart';

class PurchaseUseCase {
  final PurchaseRepo _repo = PurchaseRepoImpl();

  Future<List<Purchase>> purchases() => _repo.purchases();
  void add(String pesticide, Quantity quantity, double price) =>
      _repo.add(Purchase(pesticide, quantity, price));
}

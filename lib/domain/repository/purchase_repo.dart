import 'package:vineyard_guard/domain/entity/purchase.dart';

abstract class PurchaseRepo {
  Future<List<Purchase>> purchases();
  void add(Purchase p);
  void remove(Purchase p);
}

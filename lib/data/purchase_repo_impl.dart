import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vineyard_guard/domain/entity/purchase.dart';
import 'package:vineyard_guard/domain/repository/purchase_repo.dart';

class PurchaseRepoImpl extends PurchaseRepo {
  final CollectionReference _purchasesRef = FirebaseFirestore.instance
      .collection('purchase')
      .withConverter<Purchase>(
          fromFirestore: (snapshot, _) => Purchase.fromJson(snapshot.data()!),
          toFirestore: (purchase, _) => purchase.toJson());

  @override
  void add(Purchase p) async => await _purchasesRef.add(p);

  @override
  Future<List<Purchase>> purchases() => _purchasesRef.get().then(
      (s) => s.docs.map((snapshot) => snapshot.data()! as Purchase).toList());

  @override
  void remove(Purchase p) {
    // TODO: implement remove
  }
}

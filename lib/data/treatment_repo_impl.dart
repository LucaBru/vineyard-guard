import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vineyard_guard/domain/entity/treatment.dart';
import 'package:vineyard_guard/domain/repository/treament_repo.dart';

class TreatmentRepoImpl extends TreatmentRepo {
  final CollectionReference _treatmentsRef = FirebaseFirestore.instance
      .collection('treatment')
      .withConverter<Treatment>(
          fromFirestore: (snapshot, _) =>
              Treatment.fromJson({"id": snapshot.id, ...snapshot.data()!}),
          toFirestore: (treatment, _) => treatment.toJson());

  @override
  void add(Treatment t) => _treatmentsRef.add(t);

  @override
  void remove(String id) => _treatmentsRef.doc(id).delete();

  @override
  Future<List<Treatment>> treatments() => _treatmentsRef.get().then(
      (s) => s.docs.map((snapshot) => snapshot.data()! as Treatment).toList());
}

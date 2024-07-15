import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vineyard_guard/domain/entity/treatment.dart';
import 'package:vineyard_guard/domain/repository/treament_repo.dart';

class TreatmentRepoImpl extends TreatmentRepo {
  final CollectionReference _treatmentsRef = FirebaseFirestore.instance
      .collection('treatment')
      .withConverter<Treatment>(
          fromFirestore: (snapshot, _) => Treatment.fromJson(snapshot.data()!),
          toFirestore: (treatment, _) => treatment.toJson());

  @override
  void add(Treatment t) async => await _treatmentsRef.add(t);

  @override
  void remove(Treatment t) {}

  @override
  Future<List<Treatment>> treatments() => _treatmentsRef.get().then(
      (s) => s.docs.map((snapshot) => snapshot.data()! as Treatment).toList());
}

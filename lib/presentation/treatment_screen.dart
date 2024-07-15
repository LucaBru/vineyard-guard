import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vineyard_guard/domain/entity/treatment.dart';
import 'package:vineyard_guard/domain/use_case/treatment_uc.dart';
import 'package:vineyard_guard/presentation/error_widget.dart';

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  late Future<List<Treatment>> _request;

  Future<List<Treatment>> _fetchTreatments() async =>
      _request = TreatmentUseCase().treatments();

  @override
  void initState() {
    super.initState();
    _fetchTreatments();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: _floatingButton(),
        body: _futureWidget(context),
      );

  Widget _floatingButton() => FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => throw UnimplementedError());

  Widget _futureWidget(BuildContext context) => FutureBuilder(
      future: _request,
      builder: (context, snapshot) => switch (snapshot.connectionState) {
            ConnectionState.waiting => const Text(''),
            ConnectionState.done =>
              _treatmentsList(snapshot.data ?? [], context),
            _ => const CustomErrorWidget()
          });

  Widget _treatmentsList(List<Treatment> treatments, BuildContext context) =>
      ListView.builder(
          itemCount: treatments.length,
          itemBuilder: (context, index) => Dismissible(
              key: ValueKey(index),
              background: Container(
                color: Colors.red,
              ),
              child: _treatmentCard(treatments[index]),
              onDismissed: (_) {
                setState(() {
                  treatments.removeAt(index);
                });
              }));

  Widget _treatmentCard(Treatment treatment) => Card(
          child: ExpansionTile(
        title: Text(DateFormat('EEEE d MMMM y').format(treatment.date)),
        children: treatment.pesticides.entries
            .map((entry) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                      '${entry.key}: ${entry.value.value} ${entry.value.unit.name}'),
                ))
            .toList(),
      ));
}

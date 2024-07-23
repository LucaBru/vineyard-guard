import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';
import 'package:vineyard_guard/domain/entity/treatment.dart';
import 'package:vineyard_guard/domain/use_case/treatment_uc.dart';
import 'package:vineyard_guard/presentation/error_widget.dart';
import 'package:vineyard_guard/presentation/treatment/add_treatment_form.dart';

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  final TreatmentUseCase _useCase = TreatmentUseCase();
  late Future<List<Treatment>> _request;
  late List<Treatment> _treatments;

  Future<List<Treatment>> _fetchTreatments() async =>
      _request = _useCase.treatments();

  @override
  void initState() {
    super.initState();
    _fetchTreatments();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Vineyard treatments"),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        floatingActionButton: _floatingButton(),
        body: _futureWidget(context),
      );

  Widget _floatingButton() => FloatingActionButton(
      onPressed: _doTreatment, child: const Icon(Icons.add));

  void _doTreatment() async {
    TreatmentRequest request = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddTreatmentForm(),
        ));

    Treatment t = Treatment.autogenerateId(request.date, request.pesticides);
    _useCase.add(t);
    setState(() {
      _treatments.insert(0, t);
    });
  }

  Widget _futureWidget(BuildContext context) => FutureBuilder(
      future: _request,
      builder: (context, snapshot) => switch (snapshot.connectionState) {
            ConnectionState.waiting => const Center(
                child: CircularProgressIndicator(),
              ),
            ConnectionState.done => _successfulRequest(snapshot, context),
            _ => const CustomErrorWidget('Error while retrieving treatments')
          });

  Widget _successfulRequest(
      AsyncSnapshot<List<Treatment>> snapshot, BuildContext context) {
    _treatments = snapshot.data ?? [];
    _treatments.sort((a, b) => b.date.compareTo(a.date));
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _treatments.length,
          itemBuilder: (context, index) => Dismissible(
              key: ValueKey(_treatments[index].id),
              background: Container(
                color: Colors.red,
              ),
              child: _treatmentCard(_treatments[index]),
              onDismissed: (_) {
                _useCase.remove(_treatments[index].id);
                setState(() {
                  _treatments.removeAt(index);
                });
              })),
    );
  }

  Widget _treatmentCard(Treatment treatment) => Card.filled(
          child: ExpansionTile(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: const Icon(Icons.engineering),
        title: Text(DateFormat('EEEE d MMMM y').format(treatment.date)),
        shape: const Border(),
        children: treatment.pesticides.entries
            .map(
              (entry) => ListTile(
                tileColor: Theme.of(context).colorScheme.surfaceContainer,
                leading: const Icon(Icons.medication),
                title: Row(
                  children: [
                    Text(
                        '${entry.key}: ${entry.value.value} ${entry.value.unit.name}'),
                  ],
                ),
              ),
            )
            .toList(),
      ));
}

typedef TreatmentRequest = ({DateTime date, Map<String, Quantity> pesticides});

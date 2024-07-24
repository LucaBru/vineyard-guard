import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';
import 'package:vineyard_guard/domain/entity/treatment.dart';
import 'package:vineyard_guard/domain/use_case/treatment_uc.dart';
import 'package:vineyard_guard/presentation/empty_list_widget.dart';
import 'package:vineyard_guard/presentation/error_widget.dart';
import 'package:vineyard_guard/presentation/treatment/add_treatment_form.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

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
          actions: [
            IconButton(
                tooltip: 'Share treatments as pdf file',
                onPressed: _shareTreatmentsPdf,
                icon: const Icon(Icons.share)),
          ],
        ),
        floatingActionButton: _floatingButton(),
        body: _futureWidget(context),
      );

  Widget _floatingButton() => FloatingActionButton(
      tooltip: 'Add treatment',
      onPressed: _doTreatment,
      child: const Icon(Icons.add));

  Future<void> _shareTreatmentsPdf() async {
    PdfDocument doc = await _useCase.pdf(_treatments);
    Share.shareXFiles([
      XFile.fromData(Uint8List.fromList(doc.saveSync()),
          mimeType: 'application/pdf')
    ]);
  }

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
    return switch ((_treatments, snapshot.hasError)) {
      ([], false) => const EmptyListWidget('treatment'),
      (_, false) => Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Semantics(
            label: 'List of treatments',
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
          ),
        ),
      (_, true) => const CustomErrorWidget('Error while retrieving treatments')
    };
  }

  Widget _treatmentCard(Treatment treatment) {
    String treatmentDateFormatted =
        DateFormat('EEEE d MMMM y').format(treatment.date);
    return Card.filled(
        child: ExpansionTile(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      leading: const Icon(Icons.engineering),
      title: Text(
        treatmentDateFormatted,
        semanticsLabel: 'Treatment of $treatmentDateFormatted',
      ),
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
}

typedef TreatmentRequest = ({DateTime date, Map<String, Quantity> pesticides});

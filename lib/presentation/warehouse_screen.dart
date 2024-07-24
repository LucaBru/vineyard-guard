import 'package:flutter/material.dart';
import 'package:vineyard_guard/domain/entity/quantity.dart';
import 'package:vineyard_guard/domain/entity/stocked_pesticide.dart';
import 'package:vineyard_guard/domain/use_case/warehouse_uc.dart';
import 'package:vineyard_guard/presentation/empty_list_widget.dart';
import 'package:vineyard_guard/presentation/error_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WarehouseScreen extends StatefulWidget {
  const WarehouseScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  late Future<List<StockedPesticide>> _request;
  late List<StockedPesticide> _stocks;

  @override
  void initState() {
    super.initState();
    _request = WarehouseUseCase().stockedPesticides();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text("Stocked pesticides"),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer),
        body: FutureBuilder(
          future: _request,
          builder: (context, snapshot) => switch (snapshot.connectionState) {
            ConnectionState.waiting => const Center(
                child: CircularProgressIndicator(),
              ),
            ConnectionState.done => _successfulRequest(snapshot, context),
            _ => const CustomErrorWidget(
                'Error while retrieving stocked pesticides')
          },
        ),
      );

  Widget _successfulRequest(
      AsyncSnapshot<List<StockedPesticide>> snapshot, BuildContext context) {
    _stocks = snapshot.data ?? [];
    return switch ((_stocks, snapshot.hasError)) {
      ([], false) => const EmptyListWidget('pesticide purchase'),
      (_, false) => ListView(children: [
          _pieChart(),
          Semantics(
              label: 'List of stocked pesticides in the warehouse',
              child: Column(
                  children:
                      _stocks.map((stock) => _stockCard(stock)).toList())),
        ]),
      (_, true) =>
        const CustomErrorWidget('Error while retrieving pesticide purchases')
    };
  }

  Widget _pieChart() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
        child: Card.filled(
          child: Semantics(
            label:
                'Pie chart where each slice represent a stocked pesticide in the warehouse. Such information is also available in the list below',
            child: ExcludeSemantics(
              child: SfCircularChart(
                  title: const ChartTitle(text: 'Stocks'),
                  legend: const Legend(isVisible: true),
                  series: <CircularSeries>[
                    DoughnutSeries<StockedPesticide, String>(
                        dataSource: _stocks,
                        animationDuration: 0,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                        dataLabelMapper: (StockedPesticide slice, _) =>
                            '${slice.available} ${slice.unit.name}',
                        xValueMapper: (StockedPesticide slice, _) =>
                            slice.pesticide,
                        yValueMapper: (StockedPesticide slice, _) =>
                            slice.available),
                  ]),
            ),
          ),
        ),
      );

  Widget _stockCard(StockedPesticide stock) => Card.filled(
        child: ListTile(
            leading: const Icon(Icons.inventory),
            title: Text(
              stock.pesticide,
              semanticsLabel: 'Stock of ${stock.pesticide}',
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Purchased: ${stock.purchased} ${stock.unit.name}',
                  semanticsLabel:
                      'Purchased: ${stock.purchased} ${stock.unit == UnitOfMeasure.KG ? 'kilograms' : 'liters'}',
                ),
                Text(
                  'Used: ${stock.used} ${stock.unit.name}',
                  semanticsLabel:
                      'Used:  ${stock.used} ${stock.unit == UnitOfMeasure.KG ? 'kilograms' : 'liters'}',
                ),
              ],
            )),
      );
}

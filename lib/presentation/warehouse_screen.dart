import 'package:flutter/material.dart';
import 'package:vineyard_guard/domain/entity/stocked_pesticide.dart';
import 'package:vineyard_guard/domain/use_case/warehouse_uc.dart';
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
        appBar: AppBar(title: const Text("Stocked pesticides")),
        body: FutureBuilder(
          future: _request,
          builder: (context, snapshot) => switch (snapshot.connectionState) {
            ConnectionState.waiting => const Text(''),
            ConnectionState.done => _successfulRequest(snapshot, context),
            _ => const CustomErrorWidget()
          },
        ),
      );

  Widget _successfulRequest(
      AsyncSnapshot<List<StockedPesticide>> snapshot, BuildContext context) {
    _stocks = snapshot.data ?? [];
    return ListView(children: [
      _pieChart(),
      ..._stocks.map((stock) => _stockCard(stock)),
    ]);
  }

  Widget _pieChart() => Card(
        child: SfCircularChart(
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
                  xValueMapper: (StockedPesticide slice, _) => slice.pesticide,
                  yValueMapper: (StockedPesticide slice, _) => slice.available),
            ]),
      );

  Widget _stockCard(StockedPesticide stock) => Card(
        child: ListTile(
            title: Text(stock.pesticide),
            subtitle:
                Text('Purchased: ${stock.purchased}, Used: ${stock.used}')),
      );
}

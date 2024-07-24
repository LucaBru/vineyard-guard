import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vineyard_guard/domain/entity/weather.dart';
import 'package:vineyard_guard/domain/use_case/weather_uc.dart';
import 'package:vineyard_guard/presentation/error_widget.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<List<Weather>> _request;
  late List<Weather> _weather;

  @override
  void initState() {
    super.initState();
    _request = WeatherUseCase().weatherSinceLastTreatment();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: const Text('Weather since last treatment'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer),
      body: FutureBuilder(
        future: _request,
        builder: (context, snapshot) => switch (snapshot.connectionState) {
          ConnectionState.waiting => const Center(
              child: CircularProgressIndicator(),
            ),
          ConnectionState.done => _successfulRequest(snapshot, context),
          _ => const CustomErrorWidget(
              'Error while retrieving weather since last treatment')
        },
      ));

  _successfulRequest(AsyncSnapshot snapshot, BuildContext context) {
    _weather = snapshot.data ?? [];

    return switch ((_weather, snapshot.hasError)) {
      ([], false) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.hourglass_bottom,
              color: Theme.of(context).colorScheme.error,
              size: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'Not passed a day from last vineyard treatment, wait more time to see weather statistics',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold),
              ),
            )
          ]),
        ),
      (_, false) => ListView(
          children: [
            const Padding(padding: const EdgeInsets.fromLTRB(0, 4, 0, 0)),
            _averagePropertyWidget(
                Icon(Icons.sunny, size: 28, color: Colors.yellow[700]),
                _propertyAverage((w) => w.maxTemperature),
                'Average max temperature',
                '˚',
                'celsius degree'),
            _averagePropertyWidget(
                Icon(Icons.ac_unit, size: 28, color: Colors.blue[600]),
                _propertyAverage((w) => w.minTemperature),
                'Average min temperature',
                '˚',
                'celsius degree'),
            _averagePropertyWidget(
                const Icon(
                  Icons.thunderstorm,
                  size: 28,
                ),
                _weather.map((w) => w.precipitation).reduce((a, b) => a + b),
                'Precipitation sum',
                'mm'),
            _precipitationChart(),
            _temperaturesChart()
          ],
        ),
      (_, true) =>
        const CustomErrorWidget('Error while retrieving weather stats')
    };
  }

  _propertyAverage(double Function(Weather) retrieveProperty) =>
      (_weather.map(retrieveProperty).reduce((a, b) => a + b) /
          _weather.length);

  _averagePropertyWidget(
          Icon icon, double value, String propertyName, String unit,
          [String? unitSemantics]) =>
      Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('$propertyName: '),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Text(
                          '${value.toStringAsFixed(1)} $unit',
                          semanticsLabel:
                              '${value.toStringAsFixed(1)} ${unitSemantics ?? unit}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _precipitationChart() => Card.filled(
        child: Semantics(
          label:
              '''Bar chart that represent the precipitation in the days since last treatment until today, 
              it shows that the rain were 
              ${_weather.where((w) => w.precipitation > 0).map((w) => '${w.precipitation} mm on ${DateFormat('dd of MMMM').format(w.day)}')}''',
          child: ExcludeSemantics(
            child: SfCartesianChart(
                title: const ChartTitle(text: 'Precipitations'),
                primaryXAxis: _getDateTimeAxis(),
                primaryYAxis: const NumericAxis(),
                series: [
                  ColumnSeries<({DateTime day, double precipitation}),
                          DateTime>(
                      dataSource: _weather
                          .map((w) =>
                              (day: w.day, precipitation: w.precipitation))
                          .toList(),
                      animationDuration: 0,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(5)),
                      xValueMapper: (data, _) => data.day,
                      yValueMapper: (data, _) => data.precipitation,
                      name: 'Gold',
                      color: const Color.fromRGBO(8, 142, 255, 1))
                ]),
          ),
        ),
      );

  _temperaturesChart() => Card.filled(
        child: Semantics(
          label: '''
            Line chart that represent the maximum and minimum temperatures in the days since last treatment until today,
            it shows that the maximum temperatures were
            ${_weather.map((w) => '${w.maxTemperature} on ${DateFormat('dd of MMMM').format(w.day)}')}
            while the minimum temperatures were
            ${_weather.map((w) => '${w.minTemperature} on ${DateFormat('dd of MMMM').format(w.day)}')}
            ''',
          child: ExcludeSemantics(
            child: SfCartesianChart(
                primaryXAxis: _getDateTimeAxis(),
                primaryYAxis: const NumericAxis(labelFormat: '{value}°'),
                title: const ChartTitle(text: 'Temperatures'),
                legend: const Legend(isVisible: true),
                series: [_maxTempSeries(), _minTempSeries()]),
          ),
        ),
      );

  _maxTempSeries() => AreaSeries(
        animationDuration: 0,
        dataSource:
            _weather.map((w) => (day: w.day, temp: w.maxTemperature)).toList(),
        borderColor: Colors.orange,
        borderWidth: 3,
        xValueMapper: (pastDayWeather, _) => pastDayWeather.day,
        yValueMapper: (pastDayWeather, _) => pastDayWeather.temp,
        name: 'Max',
        color: const Color.fromRGBO(255, 150, 0, 0.2),
      );

  _minTempSeries() => AreaSeries(
        animationDuration: 0,
        dataSource:
            _weather.map((w) => (day: w.day, temp: w.minTemperature)).toList(),
        borderColor: Colors.green,
        borderWidth: 3,
        xValueMapper: (pastDayWeather, _) => pastDayWeather.day,
        yValueMapper: (pastDayWeather, _) => pastDayWeather.temp,
        name: 'Min',
        color: const Color.fromRGBO(50, 205, 50, 0.2),
      );

  _getDateTimeAxis() => DateTimeAxis(
        dateFormat: DateFormat("dd/MM"),
        intervalType: DateTimeIntervalType.days,
        labelRotation: -90,
        interval: 1,
      );
}

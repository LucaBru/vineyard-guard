import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vineyard_guard/firebase_options.dart';
import 'package:vineyard_guard/presentation/purchase/purchase_screen.dart';
import 'package:vineyard_guard/presentation/treatment/treatment_screen.dart';
import 'package:vineyard_guard/presentation/warehouse_screen.dart';
import 'package:vineyard_guard/presentation/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const VineyardGuardApp());
}

class VineyardGuardApp extends StatelessWidget {
  const VineyardGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VineyardGuard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 110, 174, 37)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final labels = ['Treatments', 'Purchases', 'Warehouse', 'Weather'];
    final icons = [
      Icons.agriculture,
      Icons.shopping_cart,
      Icons.warehouse,
      Icons.thunderstorm
    ];

    return Scaffold(
        bottomNavigationBar: NavigationBar(
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: labels.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            return NavigationDestination(
                icon: Icon(icons[index]), label: label);
          }).toList(),
        ),
        body: <Widget>[
          const TreatmentScreen(),
          const PurchaseScreen(),
          const WarehouseScreen(),
          const WeatherScreen(),
        ][currentPageIndex]);
  }
}

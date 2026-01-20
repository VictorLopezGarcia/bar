import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/order_summary_screen.dart';

void main() {
  runApp(const PremiumBarApp());
}

/// Widget principal de la aplicación.
class PremiumBarApp extends StatelessWidget {
  const PremiumBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configura la aplicación con el tema y las rutas de navegación.
    return MaterialApp(
      title: 'Bar Meson Pepe',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      routes: {
        '/': (context) => const HomeScreen(), // Pantalla principal
        '/resumen': (context) =>
            const OrderSummaryScreen(), // Pantalla de resumen de pedidos
      },
      initialRoute: '/',
    );
  }
}

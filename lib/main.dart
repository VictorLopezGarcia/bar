import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/order_summary_screen.dart';

void main() {
  runApp(const PremiumBarApp());
}

class PremiumBarApp extends StatelessWidget {
  const PremiumBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bar Meson Pepe',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      routes: {
        '/': (context) => const HomeScreen(),
        '/resumen': (context) => const OrderSummaryScreen(),
      },
      initialRoute: '/',
    );
  }
}

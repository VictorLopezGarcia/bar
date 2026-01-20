import 'package:flutter/material.dart';
import '../models/order.dart';
import '../viewmodels/orders_viewmodel.dart';
import '../widgets/order_card.dart';
import 'create_order_screen.dart';

/// Pantalla principal de la aplicación.
/// Muestra la lista de todos los pedidos activos y permite iniciar el proceso de creación de uno nuevo.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final OrdersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OrdersViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  /// Navega a la pantalla de crear pedido y espera el resultado.
  /// Si se crea un pedido exitosamente, se añade a la lista de pedidos activos.
  Future<void> _navigateToCreateOrder() async {
    final result = await Navigator.push<Order>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrderScreen(orderViewModel: _viewModel),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      _viewModel.registerNewOrder(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bar Meson Pepe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay pedidos registrados',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Presiona el botón + para crear un nuevo pedido',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _viewModel.orders.length,
            itemBuilder: (context, index) {
              final order = _viewModel.orders[index];
              return OrderCard(order: order);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreateOrder,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Nuevo Pedido',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

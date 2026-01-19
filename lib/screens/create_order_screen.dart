import 'package:bar/viewmodels/orders_viewmodel.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../viewmodels/create_order_viewmodel.dart';
import 'product_selection_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key, required OrdersViewModel orderViewModel})
    : _orderViewModel = orderViewModel;

  final OrdersViewModel _orderViewModel;

  @override
  State<CreateOrderScreen> createState() =>
      _CreateOrderScreenState(_orderViewModel);
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  _CreateOrderScreenState(this._orderViewModel);

  final OrdersViewModel _orderViewModel;
  late final CreateOrderViewModel _viewModel;
  late final TextEditingController _tableController;

  @override
  void initState() {
    super.initState();
    _viewModel = CreateOrderViewModel();
    _tableController = TextEditingController();
    _tableController.addListener(() {
      _viewModel.updateTableNumber(_tableController.text);
    });
  }

  @override
  void dispose() {
    _tableController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _navigateToSelectProducts() async {
    final result = await Navigator.push<Map<Product, int>>(
      context,
      MaterialPageRoute(
        builder: (context) => ProductSelectionScreen(
          initialProducts: _viewModel.selectedProducts,
        ),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      _viewModel.updateProducts(result);
    }
  }

  void _navigateToSummary() {
    if (!_viewModel.validate()) {
      _showValidationError();
      return;
    }

    final order = _viewModel.createOrder();

    Navigator.pushNamed(context, '/resumen', arguments: order);
  }

  void _saveOrder() {
    if (!_viewModel.validate()) {
      _showValidationError();
      return;
    }

    if (_orderViewModel.tableAlreadyExists(_viewModel.tableNumber.trim())) {
      _showValidationError();
      return;
    }

    final order = _viewModel.createOrder();

    Navigator.pop(context, order);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _showValidationError() {
    String message = '';

    if (_viewModel.tableNumber.trim().isEmpty) {
      message = 'Por favor, ingresa el número de mesa';
    } else if (_viewModel.productCount == 0) {
      message = 'Por favor, selecciona al menos un producto';
    } else if (_orderViewModel.tableAlreadyExists(
      _viewModel.tableNumber.trim(),
    )) {
      message = 'Esta mesa ya tiene un pedido activo';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nuevo Pedido',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.8)),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información del Pedido',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.white.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _tableController,
                          decoration: InputDecoration(
                            labelText: 'Número de Mesa',
                            hintText: 'Ej: 12',
                            prefixIcon: Icon(
                              Icons.table_restaurant,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Productos Agregados',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                            ),
                            if (_viewModel.productCount > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${_viewModel.productCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (_viewModel.productCount == 0)
                          Container(
                            padding: const EdgeInsets.all(24),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No hay productos seleccionados',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Presiona "Seleccionar Productos" para agregar',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: [
                              ..._viewModel.selectedProducts.entries.map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${entry.value} x ${entry.key.name}   (${entry.key.price.toStringAsFixed(2)} € Ud.)',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                          ),
                                        ),
                                        Text(
                                          '${entry.value * entry.key.price} €',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white.withOpacity(
                                                  0.8,
                                                ),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(height: 24),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                  ),
                                  Text(
                                    '${_viewModel.totalPrice.toStringAsFixed(2)} €',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.8),
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: _navigateToSelectProducts,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Seleccionar Productos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: _viewModel.validate() ? _navigateToSummary : null,
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Ver Resumen'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: _saveOrder,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar Pedido'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                TextButton.icon(
                  onPressed: _cancel,
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancelar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.error.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

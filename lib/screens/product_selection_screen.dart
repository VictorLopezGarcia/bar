import 'package:flutter/material.dart';
import '../models/product.dart';
import '../viewmodels/product_selection_viewmodel.dart';

class ProductSelectionScreen extends StatefulWidget {
  final Map<Product, int> initialProducts;

  const ProductSelectionScreen({super.key, this.initialProducts = const {}});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  late final ProductSelectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProductSelectionViewModel();
    _viewModel.loadFromExisting(widget.initialProducts);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _confirm() {
    final selectedProducts = _viewModel.getSelectedProducts();
    Navigator.pop(context, selectedProducts);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seleccionar Productos',
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
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _viewModel.availableProducts.length,
                  itemBuilder: (context, index) {
                    final product = _viewModel.availableProducts[index];
                    final isSelected = _viewModel.isProductSelected(product.id);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: isSelected ? 4 : 2,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.6),

                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '${product.price.toStringAsFixed(2)} €',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                            ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isSelected
                                            ? ' x${_viewModel.selectedProducts[product.id]}'
                                            : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  onPressed: () {
                                    _viewModel.incrementQuantity(product.id);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  onPressed: () {
                                    _viewModel.decrementQuantity(product.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _cancel,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error.withOpacity(0.4),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _confirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.4),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Confirmar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

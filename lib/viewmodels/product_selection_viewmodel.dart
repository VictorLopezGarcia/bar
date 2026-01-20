import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products_data.dart';

/// ViewModel para la pantalla de selección de productos.
/// Gestiona la cantidad seleccionada de cada producto disponible en el menú.
class ProductSelectionViewModel extends ChangeNotifier {
  final List<Product> menu = ProductsData.availableProducts;
  final Map<String, int> _quantities = {};

  List<Product> get availableProducts => menu;
  Map<String, int> get selectedProducts => Map.from(_quantities);

  /// Verifica si un producto específico ha sido seleccionado (cantidad > 0).
  bool isProductSelected(String productId) =>
      _quantities.containsKey(productId);

  /// Obtiene la cantidad seleccionada de un producto específico.
  int getQuantity(String productId) => _quantities[productId] ?? 0;

  /// Incrementa en 1 la cantidad de un producto.
  void incrementQuantity(String productId) {
    final current = _quantities[productId] ?? 0;
    _quantities[productId] = current + 1;
    notifyListeners();
  }

  /// Decrementa en 1 la cantidad de un producto.
  /// Si la cantidad llega a 0, elimina el producto de la selección.
  void decrementQuantity(String productId) {
    if (!_quantities.containsKey(productId)) return;

    final current = _quantities[productId]!;
    if (current > 1) {
      _quantities[productId] = current - 1;
    } else {
      _quantities.remove(productId);
    }
    notifyListeners();
  }

  /// Convierte el mapa de IDs y cantidades a un mapa de objetos [Product] y cantidades.
  Map<Product, int> getSelectedProducts() {
    final result = <Product, int>{};
    for (var entry in _quantities.entries) {
      final product = menu.firstWhere((p) => p.id == entry.key);
      result[product] = entry.value;
    }
    return result;
  }

  /// Limpia toda la selección actual.
  void clearSelection() {
    _quantities.clear();
    notifyListeners();
  }

  /// Carga una selección preexistente de productos.
  void loadFromExisting(Map<Product, int> products) {
    _quantities.clear();
    for (var entry in products.entries) {
      _quantities[entry.key.id] = entry.value;
    }
    notifyListeners();
  }

  // Indica si hay al menos un producto seleccionado.
  bool get hasSelection => _quantities.isNotEmpty;

  // Devuelve el número total de items seleccionados (suma de cantidades).
  int get totalSelectedItems =>
      _quantities.isEmpty ? 0 : _quantities.values.reduce((a, b) => a + b);
}

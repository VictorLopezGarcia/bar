import 'product.dart';

/// Representa un pedido realizado por una mesa.
class Order {
  final String tableNumber; // Número o identificador de la mesa
  final Map<Product, int> products; // Mapa de productos y sus cantidades
  final DateTime createdAt; // Fecha y hora en que se creó el pedido

  Order({
    required this.tableNumber,
    required this.products,
    required this.createdAt,
  });

  /// Calcula el precio total del pedido.
  double get totalPrice {
    if (products.isEmpty) return 0.0;
    return products.entries
        .map((entry) => entry.key.price * entry.value)
        .reduce((a, b) => a + b);
  }

  /// Calcula la cantidad total de artículos en el pedido.
  int get totalItems {
    if (products.isEmpty) return 0;
    return products.values.reduce((a, b) => a + b);
  }
}

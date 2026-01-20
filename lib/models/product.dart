/// Representa un producto disponible en el menú (bebida, comida, etc.).
class Product {
  final String id; // Identificador único del producto
  final String name; // Nombre del producto para mostrar
  final double price; // Precio unitario del producto

  Product({required this.id, required this.name, required this.price});
}

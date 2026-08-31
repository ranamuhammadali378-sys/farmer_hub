class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String unit;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.unit,
    required this.description,
  });

  // Firestore → ProductModel
  factory ProductModel.fromFirestore(
      String id,
      Map<String, dynamic> data,
      ) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      stock: data['stock'] ?? 0,
      unit: data['unit'] ?? '',
      description: data['description'] ?? '',
    );
  }

  // ProductModel → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'unit': unit,
      'description': description,
    };
  }
}
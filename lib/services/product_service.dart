import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
  get _productsCollection {
    return _firestore.collection('products');
  }

  // =========================
  // ADD PRODUCT
  // =========================
  Future<void> addProduct(ProductModel product) async {
    await _productsCollection
        .doc(product.id)
        .set(product.toFirestore());
  }

  // =========================
  // GET ALL PRODUCTS
  // =========================
  Future<List<ProductModel>> getProducts() async {
    final snapshot =
    await _productsCollection.get();

    return snapshot.docs.map((doc) {
      return ProductModel.fromFirestore(
        doc.id,
        doc.data(),
      );
    }).toList();
  }

  // =========================
  // UPDATE PRODUCT
  // =========================
  Future<void> updateProduct(
      ProductModel product,
      ) async {
    await _productsCollection
        .doc(product.id)
        .update(product.toFirestore());
  }

  // =========================
  // DELETE PRODUCT
  // =========================
  Future<void> deleteProduct(
      String productId,
      ) async {
    await _productsCollection
        .doc(productId)
        .delete();
  }
}
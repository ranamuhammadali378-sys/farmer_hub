import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';
import 'admin_order_screen.dart';
import 'login_screen.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  static const green = Color(0xFF2E7D32);
  static const darkGreen = Color(0xFF1B5E20);

  final _service = ProductService();
  final _auth = FirebaseAuth.instance;
  final _search = TextEditingController();

  // IMPORTANT: Same owner UID used in Firestore Rules.
  static const ownerUid = 'ePzpMjodHsQRE94OQsDS9kFGgvl1';

  String searchText = '';

  bool get isOwner => _auth.currentUser?.uid == ownerUid;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isOwner) return const _AccessDenied();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkGreen,
        elevation: 1,
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings, color: green),
            SizedBox(width: 10),
            Text(
              'Product Management',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          _appButton(
            'Orders',
            Icons.receipt_long_outlined,
            Colors.blue,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminOrdersScreen(),
              ),
            ),
          ),
          _appButton(
            'Add Product',
            Icons.add,
            green,
            _showProductDialog,
          ),
          _appButton(
            'Logout',
            Icons.logout,
            Colors.red,
            _logout,
            last: true,
          ),
        ],
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(child: _products()),
        ],
      ),
    );
  }

  Widget _appButton(
      String text,
      IconData icon,
      Color color,
      VoidCallback action, {
        bool last = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(right: last ? 16 : 8),
      child: ElevatedButton.icon(
        onPressed: action,
        icon: Icon(icon, size: 18),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: TextField(
          controller: _search,
          onChanged: (value) => setState(
                () => searchText = value.trim().toLowerCase(),
          ),
          decoration: InputDecoration(
            hintText: 'Search products by name or category...',
            prefixIcon: const Icon(Icons.search, color: green),
            suffixIcon: searchText.isEmpty
                ? null
                : IconButton(
              onPressed: () {
                _search.clear();
                setState(() => searchText = '');
              },
              icon: const Icon(Icons.clear),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _products() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: green),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Unable to load products.\n${snapshot.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];
        final products = docs
            .map((doc) => ProductModel.fromFirestore(doc.id, doc.data()))
            .where(
              (p) =>
          searchText.isEmpty ||
              p.name.toLowerCase().contains(searchText) ||
              p.category.toLowerCase().contains(searchText),
        )
            .toList();

        if (products.isEmpty) {
          return _EmptyProducts(
            searched: searchText.isNotEmpty,
            onAdd: _showProductDialog,
          );
        }

        return LayoutBuilder(
          builder: (context, box) {
            final count = box.maxWidth >= 1200
                ? 4
                : box.maxWidth >= 850
                ? 3
                : box.maxWidth >= 550
                ? 2
                : 1;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: box.maxWidth < 600 ? 1.05 : .85,
                  ),
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    final product = products[index];
                    return _ProductCard(
                      product: product,
                      onEdit: () =>
                          _showProductDialog(product: product),
                      onDelete: () => _deleteProduct(product),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showProductDialog({ProductModel? product}) async {
    final name = TextEditingController(text: product?.name ?? '');
    final category = TextEditingController(text: product?.category ?? '');
    final description =
    TextEditingController(text: product?.description ?? '');
    final price = TextEditingController(
      text: product?.price.toString() ?? '',
    );
    final stock = TextEditingController(
      text: product?.stock.toString() ?? '',
    );
    final unit = TextEditingController(text: product?.unit ?? '');

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool saving = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> save() async {
              if (!formKey.currentState!.validate()) return;

              setDialogState(() => saving = true);

              try {
                final id = product?.id ??
                    FirebaseFirestore.instance
                        .collection('products')
                        .doc()
                        .id;

                final item = ProductModel(
                  id: id,
                  name: name.text.trim(),
                  category: category.text.trim(),
                  description: description.text.trim(),
                  price: double.parse(price.text.trim()),
                  stock: int.parse(stock.text.trim()),
                  unit: unit.text.trim(),
                );

                if (product == null) {
                  await _service.addProduct(item);
                } else {
                  await _service.updateProduct(item);
                }

                if (!context.mounted) return;
                Navigator.pop(dialogContext);

                if (!mounted) return;
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text(
                      product == null
                          ? 'Product added successfully.'
                          : 'Product updated successfully.',
                    ),
                    backgroundColor: green,
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                setDialogState(() => saving = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Operation failed: $e')),
                );
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                product == null ? 'Add Product' : 'Edit Product',
                style: const TextStyle(
                  color: darkGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _field(name, 'Product Name', Icons.inventory_2),
                        _field(
                          category,
                          'Category',
                          Icons.category_outlined,
                          hint: 'Seeds / Fertilizers / Pesticides',
                        ),
                        _field(
                          description,
                          'Description',
                          Icons.description_outlined,
                          maxLines: 3,
                          required: false,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _field(
                                price,
                                'Price',
                                Icons.payments_outlined,
                                number: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _field(
                                stock,
                                'Stock',
                                Icons.inventory_outlined,
                                integer: true,
                              ),
                            ),
                          ],
                        ),
                        _field(
                          unit,
                          'Unit',
                          Icons.straighten_outlined,
                          hint: 'kg / litre / bag / pack',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: saving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton.icon(
                  onPressed: saving ? null : save,
                  icon: saving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.save_outlined),
                  label: Text(saving ? 'Saving...' : 'Save Product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    name.dispose();
    category.dispose();
    description.dispose();
    price.dispose();
    stock.dispose();
    unit.dispose();
  }

  Widget _field(
      TextEditingController controller,
      String label,
      IconData icon, {
        String? hint,
        bool number = false,
        bool integer = false,
        bool required = true,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: number || integer
            ? const TextInputType.numberWithOptions(decimal: true)
            : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (!required) return null;
          if (value == null || value.trim().isEmpty) {
            return 'Enter $label.';
          }

          if (number && double.tryParse(value.trim()) == null) {
            return 'Enter a valid price.';
          }

          if (integer && int.tryParse(value.trim()) == null) {
            return 'Enter a valid stock.';
          }

          return null;
        },
      ),
    );
  }

  Future<void> _deleteProduct(ProductModel product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Product?'),
        content: Text(
          'Are you sure you want to delete "${product.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _service.deleteProduct(product.id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully.'),
          backgroundColor: green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  static const green = Color(0xFF2E7D32);
  static const darkGreen = Color(0xFF1B5E20);
  static const lightGreen = Color(0xFFE8F5E9);

  @override
  Widget build(BuildContext context) {
    final out = product.stock <= 0;

    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 82,
              width: double.infinity,
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.agriculture,
                size: 42,
                color: green,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.category,
              style: const TextStyle(
                color: green,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: darkGreen,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              product.description.isEmpty
                  ? 'No description'
                  : product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rs. ${product.price}',
                  style: const TextStyle(
                    color: green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${product.stock} ${product.unit}',
                  style: TextStyle(
                    color: out ? Colors.red : Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: green,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Delete',
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  final bool searched;
  final VoidCallback onAdd;

  const _EmptyProducts({
    required this.searched,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            searched
                ? Icons.search_off
                : Icons.inventory_2_outlined,
            size: 65,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 15),
          Text(
            searched ? 'No products found' : 'No Products Yet',
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searched
                ? 'Try another product name or category.'
                : 'Add your first agricultural product.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          if (!searched) ...[
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AccessDenied extends StatelessWidget {
  const _AccessDenied();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Access Denied')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 65, color: Colors.red),
            SizedBox(height: 15),
            Text(
              'Admin Access Required',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Only the shop owner can manage products.'),
          ],
        ),
      ),
    );
  }
}
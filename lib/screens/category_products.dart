import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'order_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
final String category;
final IconData icon;

const CategoryProductsScreen({
super.key,
required this.category,
required this.icon,
});

// =============================================================
// COLORS
// =============================================================

static const Color primaryGreen = Color(0xFF2E7D32);
static const Color darkGreen = Color(0xFF1B5E20);
static const Color lightGreen = Color(0xFFE8F5E9);

// =============================================================
// RESPONSIVE GRID
// =============================================================

int _getCrossAxisCount(double width) {
if (width < 600) {
return 1;
} else if (width < 900) {
return 2;
} else if (width < 1200) {
return 3;
}

return 4;
}

// =============================================================
// BUILD
// =============================================================

@override
Widget build(BuildContext context) {
final width = MediaQuery.of(context).size.width;

final mobile = width < 600;

return Scaffold(
backgroundColor: Colors.grey.shade50,

// =========================================================
// APP BAR
// =========================================================

appBar: AppBar(
backgroundColor: Colors.white,
foregroundColor: darkGreen,
elevation: 1,
title: Row(
children: [
Icon(
icon,
color: primaryGreen,
),
const SizedBox(width: 10),
Expanded(
child: Text(
category,
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
),
],
),
),

// =========================================================
// PRODUCTS STREAM
// =========================================================

body: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance
.collection('products')
.where(
'category',
isEqualTo: category,
)
.snapshots(),

builder: (context, snapshot) {
// =====================================================
// LOADING
// =====================================================

if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(
color: primaryGreen,
),
);
}

// =====================================================
// ERROR
// =====================================================

if (snapshot.hasError) {
return Center(
child: Padding(
padding: const EdgeInsets.all(25),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
Icons.error_outline,
size: 60,
color: Colors.red.shade400,
),
const SizedBox(height: 15),
const Text(
'Unable to load products',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: darkGreen,
),
),
const SizedBox(height: 8),
Text(
'${snapshot.error}',
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.grey.shade600,
),
),
],
),
),
);
}

// =====================================================
// PRODUCTS
// =====================================================

final products = snapshot.data?.docs ?? [];

// =====================================================
// EMPTY CATEGORY
// =====================================================

if (products.isEmpty) {
return _emptyCategory();
}

// =====================================================
// PRODUCTS CONTENT
// =====================================================

return Column(
children: [
// =================================================
// CATEGORY HEADER
// =================================================

Container(
width: double.infinity,
padding: EdgeInsets.symmetric(
horizontal: mobile ? 20 : 35,
vertical: mobile ? 25 : 30,
),
decoration: const BoxDecoration(
color: Colors.white,
border: Border(
bottom: BorderSide(
color: Color(0xFFE0E0E0),
),
),
),
child: Center(
child: ConstrainedBox(
constraints: const BoxConstraints(
maxWidth: 1400,
),
child: Row(
children: [
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: lightGreen,
borderRadius:
BorderRadius.circular(14),
),
child: Icon(
icon,
color: primaryGreen,
size: 30,
),
),

const SizedBox(width: 15),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
category,
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: darkGreen,
),
),

const SizedBox(height: 4),

Text(
'${products.length} products available',
style: TextStyle(
color: Colors.grey.shade600,
fontSize: 14,
),
),
],
),
),
],
),
),
),
),
  // =================================================
  // PRODUCTS GRID
  // =================================================

  Expanded(
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1400,
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(
            mobile ? 18 : 30,
          ),

          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
            _getCrossAxisCount(width),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,

            // Slightly more height because
            // Order Now button is included.
            childAspectRatio:
            mobile ? 0.92 : 0.72,
          ),

          itemCount: products.length,

          itemBuilder: (context, index) {
            return _categoryProductCard(
              context,
              products[index],
            );
          },
        ),
      ),
    ),
  ),
],
);
},
),
);
}

  // =============================================================
  // PRODUCT CARD
  // =============================================================

  Widget _categoryProductCard(
      BuildContext context,
      QueryDocumentSnapshot doc,
      ) {
    final data = doc.data() as Map<String, dynamic>;

    final String name =
        data['name']?.toString() ?? 'Unnamed Product';

    final String description =
        data['description']?.toString() ??
            'No description available';

    final String unit =
        data['unit']?.toString() ?? '';

    final num price =
        data['price'] ?? 0;

    final num stock =
        data['stock'] ?? 0;

    final bool outOfStock =
        stock <= 0;

    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            // =================================================
            // IMAGE AREA
            // =================================================

            Container(
              width: double.infinity,
              height: 105,

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    lightGreen,
                    Color(0xFFF5FFF6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius:
                BorderRadius.circular(16),
              ),

              child: Icon(
                icon,
                size: 50,
                color: primaryGreen,
              ),
            ),

            const SizedBox(height: 14),

            // =================================================
            // NAME
            // =================================================

            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 7),

            // =================================================
            // DESCRIPTION
            // =================================================

            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                color: Colors.grey.shade600,
              ),
            ),

            const Spacer(),

            // =================================================
            // PRICE
            // =================================================

            Text(
              'Rs. $price',

              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),

            const SizedBox(height: 6),

            // =================================================
            // STOCK
            // =================================================

            Row(
              children: [
                Icon(
                  outOfStock
                      ? Icons.remove_shopping_cart
                      : Icons.inventory_2_outlined,

                  size: 16,

                  color: outOfStock
                      ? Colors.red
                      : Colors.grey.shade700,
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    outOfStock
                        ? 'Currently unavailable'
                        : 'Stock: $stock $unit',

                    overflow:
                    TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 12,

                      color: outOfStock
                          ? Colors.red
                          : Colors.grey.shade700,

                      fontWeight: outOfStock
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // =================================================
            // ORDER BUTTON
            // =================================================

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: outOfStock
                    ? null
                    : () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          OrderScreen(
                            productName: name,
                            category: category,
                            price: price,
                            stock: stock,
                            unit: unit,
                          ),
                    ),
                  );
                },

                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 19,
                ),

                label: Text(
                  outOfStock
                      ? 'Out of Stock'
                      : 'Order Now',
                ),

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  primaryGreen,

                  foregroundColor:
                  Colors.white,

                  disabledBackgroundColor:
                  Colors.grey.shade300,

                  disabledForegroundColor:
                  Colors.grey.shade600,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 13,
                  ),

                  elevation: 0,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // EMPTY CATEGORY
  // =============================================================

  Widget _emptyCategory() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              icon,
              size: 75,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 18),

            Text(
              'No $category Available',

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Please check back later.',

              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'order_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
static const Color primaryGreen = Color(0xFF2E7D32);
static const Color darkGreen = Color(0xFF1B5E20);
static const Color lightGreen = Color(0xFFE8F5E9);

// =============================================================
// SEARCH
// =============================================================

final TextEditingController _searchController =
TextEditingController();

String _searchQuery = '';

String _selectedCategory = 'All';

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
} else {
return 4;
}
}

// =============================================================
// DISPOSE
// =============================================================

@override
void dispose() {
_searchController.dispose();
super.dispose();
}

// =============================================================
// FILTER PRODUCTS
// =============================================================

List<QueryDocumentSnapshot> _filterProducts(
List<QueryDocumentSnapshot> products,
) {
return products.where((doc) {
final data =
doc.data() as Map<String, dynamic>;

final name =
data['name']?.toString().toLowerCase() ?? '';

final category =
data['category']?.toString() ?? '';

final matchesSearch =
name.contains(_searchQuery.toLowerCase());

final matchesCategory =
_selectedCategory == 'All' ||
category == _selectedCategory;

return matchesSearch && matchesCategory;
}).toList();
}

// =============================================================
// CATEGORY LIST
// =============================================================

List<String> _getCategories(
List<QueryDocumentSnapshot> products,
) {
final categories = <String>{'All'};

for (final doc in products) {
final data =
doc.data() as Map<String, dynamic>;

final category =
data['category']?.toString().trim() ?? '';

if (category.isNotEmpty) {
categories.add(category);
}
}

return categories.toList();
}

// =============================================================
// SEARCH HEADER
// =============================================================

Widget _searchSection(
BuildContext context,
List<QueryDocumentSnapshot> products,
) {
final categories = _getCategories(products);

return Container(
width: double.infinity,
padding: const EdgeInsets.fromLTRB(
20,
20,
20,
18,
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
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
// =================================================
// SEARCH FIELD
// =================================================

TextField(
controller: _searchController,
onChanged: (value) {
setState(() {
_searchQuery = value.trim();
});
},
decoration: InputDecoration(
hintText:
'Search products by name...',
prefixIcon: const Icon(
Icons.search,
color: primaryGreen,
),
suffixIcon:
_searchQuery.isNotEmpty
? IconButton(
tooltip: 'Clear search',
icon: const Icon(
Icons.clear,
),
onPressed: () {
_searchController.clear();

setState(() {
_searchQuery = '';
});
},
)
: null,
filled: true,
fillColor: Colors.grey.shade50,
contentPadding:
const EdgeInsets.symmetric(
vertical: 16,
),
border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(14),
borderSide: BorderSide(
color: Colors.grey.shade300,
),
),
enabledBorder:
OutlineInputBorder(
borderRadius:
BorderRadius.circular(14),
borderSide: BorderSide(
color: Colors.grey.shade300,
),
),
focusedBorder:
const OutlineInputBorder(
borderRadius:
BorderRadius.all(
Radius.circular(14),
),
borderSide: BorderSide(
color: primaryGreen,
width: 2,
),
),
),
),

const SizedBox(height: 16),

// =================================================
// CATEGORY FILTER
// =================================================

SingleChildScrollView(
scrollDirection: Axis.horizontal,
child: Row(
children: categories.map((category) {
final selected =
_selectedCategory == category;

return Padding(
padding:
const EdgeInsets.only(
right: 10,
),
child: ChoiceChip(
label: Text(category),
selected: selected,
onSelected: (_) {
setState(() {
_selectedCategory =
category;
});
},
selectedColor: lightGreen,
checkmarkColor:
primaryGreen,
labelStyle: TextStyle(
color: selected
? darkGreen
: Colors.grey.shade700,
fontWeight: selected
? FontWeight.bold
: FontWeight.normal,
),
side: BorderSide(
color: selected
? primaryGreen
: Colors.grey.shade300,
),
),
);
}).toList(),
),
),
],
),
),
),
);
}

// =============================================================
// PRODUCT CARD
// =============================================================

Widget _productCard(
BuildContext context,
QueryDocumentSnapshot doc,
) {
final data =
doc.data() as Map<String, dynamic>;

final String name =
data['name']?.toString() ??
'Unnamed Product';

final String category =
data['category']?.toString() ??
'Other';

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
borderRadius:
BorderRadius.circular(20),
),
clipBehavior: Clip.antiAlias,
child: Padding(
padding:
const EdgeInsets.all(18),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
// =================================================
// PRODUCT IMAGE AREA
// =================================================

Stack(
children: [
Container(
width: double.infinity,
height: 110,
decoration:
BoxDecoration(
gradient:
const LinearGradient(
colors: [
lightGreen,
Color(0xFFF5FFF6),
],
begin:
Alignment.topLeft,
end:
Alignment.bottomRight,
),
borderRadius:
BorderRadius.circular(
16,
),
),
child: const Icon(
Icons.agriculture,
size: 52,
color: primaryGreen,
),
),

// STOCK BADGE
Positioned(
top: 10,
right: 10,
child: Container(
padding:
const EdgeInsets.symmetric(
horizontal: 10,
vertical: 6,
),
decoration:
BoxDecoration(
color: outOfStock
? Colors.red.shade50
: Colors.white,
borderRadius:
BorderRadius.circular(
20,
),
border: Border.all(
color: outOfStock
? Colors.red.shade200
: Colors.grey.shade200,
),
),
child: Text(
outOfStock
? 'Out of stock'
: 'In stock',
style: TextStyle(
fontSize: 11,
fontWeight:
FontWeight.w600,
color: outOfStock
? Colors.red
: primaryGreen,
),
),
),
),
],
),

const SizedBox(height: 16),

// =================================================
// CATEGORY
// =================================================

Container(
padding:
const EdgeInsets.symmetric(
horizontal: 9,
vertical: 5,
),
decoration:
BoxDecoration(
color: lightGreen,
borderRadius:
BorderRadius.circular(8),
),
child: Text(
category,
style:
const TextStyle(
fontSize: 12,
color: primaryGreen,
fontWeight:
FontWeight.w600,
),
),
),

const SizedBox(height: 9),

// =================================================
// NAME
// =================================================

Text(
name,
maxLines: 1,
overflow:
TextOverflow.ellipsis,
style:
const TextStyle(
fontSize: 19,
fontWeight:
FontWeight.bold,
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
overflow:
TextOverflow.ellipsis,
style: TextStyle(
fontSize: 13,
color:
Colors.grey.shade600,
height: 1.35,
),
),

const Spacer(),

// =================================================
// PRICE
// =================================================

Text(
'Rs. ${price.toString()}',
style:
const TextStyle(
fontSize: 20,
fontWeight:
FontWeight.bold,
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
? Icons
.remove_shopping_cart
: Icons
.inventory_2_outlined,
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
: Colors
.grey.shade700,
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
child:
ElevatedButton.icon(
onPressed: outOfStock
? null
: () {
Navigator.push(
context,
MaterialPageRoute(
builder:
(context) =>
OrderScreen(
productName:
name,
category:
category,
price:
price,
stock:
stock,
unit:
unit,
),
),
);
},
icon: const Icon(
Icons
.shopping_cart_outlined,
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
vertical: 14,
),
elevation: 0,
shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(
12,
),
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
// NO SEARCH RESULTS
// =============================================================

Widget _noSearchResults() {
return Center(
child: Padding(
padding:
const EdgeInsets.all(30),
child: Column(
mainAxisSize:
MainAxisSize.min,
children: [
Icon(
Icons.search_off,
size: 70,
color:
Colors.grey.shade400,
),

const SizedBox(height: 18),

const Text(
'No Products Found',
style: TextStyle(
fontSize: 22,
fontWeight:
FontWeight.bold,
color: darkGreen,
),
),

const SizedBox(height: 8),

Text(
'Try another product name or category.',
textAlign:
TextAlign.center,
style: TextStyle(
color:
Colors.grey.shade600,
fontSize: 14,
),
),

const SizedBox(height: 18),

OutlinedButton.icon(
onPressed: () {
_searchController.clear();

setState(() {
_searchQuery = '';
_selectedCategory =
'All';
});
},
icon:
const Icon(Icons.refresh),
label:
const Text('Show All Products'),
style:
OutlinedButton.styleFrom(
foregroundColor:
primaryGreen,
),
),
],
),
),
);
}

// =============================================================
  // EMPTY DATABASE
  // =============================================================

  Widget _emptyProducts() {
    return Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 70,
            color:
            Colors.grey.shade400,
          ),

          const SizedBox(height: 18),

          const Text(
            'No Products Available',
            style: TextStyle(
              fontSize: 21,
              fontWeight:
              FontWeight.bold,
              color: darkGreen,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Please check back later.',
            style: TextStyle(
              color:
              Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final isMobile = width < 600;

    return Scaffold(
      backgroundColor:
      Colors.grey.shade50,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor:
        Colors.white,
        foregroundColor:
        darkGreen,
        elevation: 1,

        title: const Row(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.agriculture,
              color: primaryGreen,
            ),

            SizedBox(width: 8),

            Text(
              'Agriculture Products',
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore
            .instance
            .collection('products')
            .snapshots(),

        builder:
            (context, snapshot) {
          // =====================================================
          // LOADING
          // =====================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
              CircularProgressIndicator(
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
                padding:
                const EdgeInsets.all(
                  24,
                ),
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 55,
                      color:
                      Colors.red.shade400,
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    const Text(
                      'Unable to load products.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      '${snapshot.error}',
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        color: Colors
                            .grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // =====================================================
          // EMPTY DATABASE
          // =====================================================

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return _emptyProducts();
          }

          final allProducts =
              snapshot.data!.docs;

          // =====================================================
          // SEARCH + CATEGORY
          // =====================================================

          final filteredProducts =
          _filterProducts(
            allProducts,
          );

          return Column(
            children: [
              // =================================================
              // SEARCH + FILTER
              // =================================================

              _searchSection(
                context,
                allProducts,
              ),

              // =================================================
              // RESULT COUNT
              // =================================================

              Padding(
                padding:
                EdgeInsets.fromLTRB(
                  isMobile ? 18 : 30,
                  18,
                  isMobile ? 18 : 30,
                  0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                    const BoxConstraints(
                      maxWidth: 1400,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 18,
                          color: primaryGreen,
                        ),

                        const SizedBox(
                          width: 7,
                        ),

                        Text(
                          'Showing ${filteredProducts.length} '
                              'of ${allProducts.length} products',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors
                                .grey.shade700,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),

                        const Spacer(),

                        if (_selectedCategory !=
                            'All' ||
                            _searchQuery
                                .isNotEmpty)
                          TextButton(
                            onPressed: () {
                              _searchController
                                  .clear();

                              setState(() {
                                _searchQuery =
                                '';
                                _selectedCategory =
                                'All';
                              });
                            },
                            child:
                            const Text(
                              'Clear filters',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // =================================================
              // PRODUCTS / NO RESULTS
              // =================================================

              Expanded(
                child: filteredProducts
                    .isEmpty
                    ? _noSearchResults()
                    : Center(
                  child:
                  ConstrainedBox(
                    constraints:
                    const BoxConstraints(
                      maxWidth: 1400,
                    ),
                    child:
                    GridView.builder(
                      padding:
                      EdgeInsets.all(
                        isMobile
                            ? 18
                            : 30,
                      ),

                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                        _getCrossAxisCount(
                          width,
                        ),
                        crossAxisSpacing:
                        isMobile
                            ? 16
                            : 22,
                        mainAxisSpacing:
                        isMobile
                            ? 16
                            : 22,
                        childAspectRatio:
                        isMobile
                            ? 0.88
                            : 0.76,
                      ),

                      itemCount:
                      filteredProducts
                          .length,

                      itemBuilder:
                          (context,
                          index) {
                        return _productCard(
                          context,
                          filteredProducts[
                          index],
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
}
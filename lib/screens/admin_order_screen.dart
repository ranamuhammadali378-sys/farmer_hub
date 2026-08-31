import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() =>
      _AdminOrdersScreenState();
}

class _AdminOrdersScreenState
    extends State<AdminOrdersScreen> {
static const Color primaryGreen =
Color(0xFF2E7D32);

static const Color darkGreen =
Color(0xFF1B5E20);

static const Color lightGreen =
Color(0xFFE8F5E9);

String _selectedStatus = 'All';

final List<String> _statuses = [
'All',
'Pending',
'Confirmed',
'Completed',
'Cancelled',
];

Color _statusColor(String status) {
switch (status.toLowerCase()) {
case 'confirmed':
return Colors.blue;

case 'completed':
return primaryGreen;

case 'cancelled':
return Colors.red;

case 'pending':
default:
return Colors.orange;
}
}

Future<void> _updateOrderStatus(
String orderId,
String status,
) async {
try {
await FirebaseFirestore.instance
.collection('orders')
.doc(orderId)
.update({
'status': status,
'updatedAt':
FieldValue.serverTimestamp(),
});

if (!mounted) return;

ScaffoldMessenger.of(context)
.showSnackBar(
SnackBar(
content: Text(
'Order marked as $status.',
),
backgroundColor: primaryGreen,
),
);
} on FirebaseException catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context)
.showSnackBar(
SnackBar(
content: Text(
'Failed to update order: '
'${e.message ?? e.code}',
),
),
);
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context)
.showSnackBar(
SnackBar(
content: Text(
'Something went wrong: $e',
),
),
);
}
}

Future<void> _confirmOrder(
String orderId,
) async {
await _updateOrderStatus(
orderId,
'Confirmed',
);
}

Future<void> _cancelOrder(
String orderId,
) async {
final confirmed =
await showDialog<bool>(
context: context,
builder: (context) {
return AlertDialog(
title: const Text(
'Cancel Order?',
),
content: const Text(
'Are you sure you want to cancel '
'this order?',
),
actions: [
TextButton(
onPressed: () {
Navigator.pop(
context,
false,
);
},
child: const Text('No'),
),
ElevatedButton(
onPressed: () {
Navigator.pop(
context,
true,
);
},
style:
ElevatedButton.styleFrom(
backgroundColor:
Colors.red,
foregroundColor:
Colors.white,
),
child: const Text(
'Cancel Order',
),
),
],
);
},
);

if (confirmed != true) return;

await _updateOrderStatus(
orderId,
'Cancelled',
);
}

String _formatDate(
Timestamp? timestamp,
) {
if (timestamp == null) {
return 'Date unavailable';
}

final date = timestamp.toDate();

final day =
date.day.toString().padLeft(2, '0');

final month =
date.month.toString().padLeft(2, '0');

final year =
date.year.toString();

final hour =
date.hour.toString().padLeft(2, '0');

final minute =
date.minute.toString().padLeft(2, '0');

return '$day/$month/$year  $hour:$minute';
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor:
Colors.grey.shade50,

appBar: AppBar(
backgroundColor:
Colors.white,
foregroundColor:
darkGreen,
elevation: 1,
title: const Row(
children: [
Icon(
Icons.receipt_long_outlined,
color: primaryGreen,
),
SizedBox(width: 10),
Text(
'Order Management',
style: TextStyle(
fontWeight:
FontWeight.bold,
),
),
],
),
),

body: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore
.instance
.collection('orders')
.orderBy(
'createdAt',
descending: true,
)
.snapshots(),

builder: (
context,
snapshot,
) {
if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child:
CircularProgressIndicator(
color: primaryGreen,
),
);
}

if (snapshot.hasError) {
return Center(
child: Padding(
padding:
const EdgeInsets.all(25),
child: Column(
mainAxisSize:
MainAxisSize.min,
children: [
Icon(
Icons.error_outline,
size: 60,
color:
Colors.red.shade400,
),
const SizedBox(
height: 15,
),
const Text(
'Unable to load orders.',
style: TextStyle(
fontSize: 20,
fontWeight:
FontWeight.bold,
color: darkGreen,
),
),
const SizedBox(
height: 8,
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

final allOrders =
snapshot.data?.docs ?? [];

final orders =
allOrders.where((doc) {
final data =
doc.data()
as Map<String, dynamic>;

final status =
data['status']
?.toString() ??
'Pending';

return _selectedStatus ==
'All' ||
status ==
_selectedStatus;
}).toList();

return Column(
children: [
_buildHeader(
allOrders.length,
),

Expanded(
child: orders.isEmpty
? _buildEmptyState()
: LayoutBuilder(
builder: (
context,
constraints,
) {
return ListView.builder(
padding:
EdgeInsets.all(
constraints.maxWidth <
600
? 16
: 28,
),
itemCount:
orders.length,
itemBuilder:
(
context,
index,
) {
return _buildOrderCard(
orders[index],
);
},
);
},
),
),
],
);
},
),
);
}

Widget _buildHeader(
    int totalOrders,
    ) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(
      20,
      20,
      20,
      16,
    ),
    decoration:
    const BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Color(0xFFE0E0E0),
        ),
      ),
    ),
    child: Center(
      child: ConstrainedBox(
        constraints:
        const BoxConstraints(
          maxWidth: 1400,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.all(
                    12,
                  ),
                  decoration:
                  BoxDecoration(
                    color: lightGreen,
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_cart_checkout,
                    color:
                    primaryGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      const Text(
                        'Customer Orders',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight:
                          FontWeight.bold,
                          color:
                          darkGreen,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '$totalOrders total orders',
                        style: TextStyle(
                          color: Colors
                              .grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 18,
            ),

            SingleChildScrollView(
              scrollDirection:
              Axis.horizontal,
              child: Row(
                children:
                _statuses.map((status) {
                  final selected =
                      _selectedStatus ==
                          status;

                  return Padding(
                    padding:
                    const EdgeInsets
                        .only(
                      right: 10,
                    ),
                    child: ChoiceChip(
                      label:
                      Text(status),
                      selected:
                      selected,
                      onSelected: (_) {
                        setState(() {
                          _selectedStatus =
                              status;
                        });
                      },
                      selectedColor:
                      lightGreen,
                      checkmarkColor:
                      primaryGreen,
                      labelStyle:
                      TextStyle(
                        color: selected
                            ? darkGreen
                            : Colors.grey
                            .shade700,
                        fontWeight:
                        selected
                            ? FontWeight
                            .bold
                            : FontWeight
                            .normal,
                      ),
                      side: BorderSide(
                        color: selected
                            ? primaryGreen
                            : Colors.grey
                            .shade300,
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

Widget _buildOrderCard(
    QueryDocumentSnapshot doc,
    ) {
  final data =
  doc.data()
  as Map<String, dynamic>;

  final customerName =
      data['customerName']
          ?.toString() ??
          'Unknown Customer';

  final phone =
      data['phone']?.toString() ??
          'No phone';

  final address =
      data['address']?.toString() ??
          'No address';

  final productName =
      data['productName']
          ?.toString() ??
          'Unknown Product';

  final category =
      data['category']?.toString() ??
          'Other';

  final unit =
      data['unit']?.toString() ??
          '';

  final quantity =
      data['quantity'] ?? 0;

  final price =
      data['price'] ?? 0;

  final totalPrice =
      data['totalPrice'] ?? 0;

  final status =
      data['status']?.toString() ??
          'Pending';

  final createdAt =
  data['createdAt']
  as Timestamp?;

  final statusColor =
  _statusColor(status);

  return Card(
    margin: const EdgeInsets.only(
      bottom: 18,
    ),
    elevation: 3,
    shadowColor: Colors.black12,
    shape:
    RoundedRectangleBorder(
      borderRadius:
      BorderRadius.circular(18),
    ),
    child: Padding(
      padding:
      const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.all(
                  12,
                ),
                decoration:
                BoxDecoration(
                  color: lightGreen,
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),
                child: const Icon(
                  Icons.agriculture,
                  color:
                  primaryGreen,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      productName,
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style:
                      const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        darkGreen,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      category,
                      style:
                      const TextStyle(
                        color:
                        primaryGreen,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration:
                BoxDecoration(
                  color: statusColor
                      .withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                  border:
                  Border.all(
                    color:
                    statusColor
                        .withValues(
                      alpha: 0.30,
                    ),
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color:
                    statusColor,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const Divider(
            height: 30,
          ),

          _infoRow(
            Icons.person_outline,
            'Farmer',
            customerName,
          ),

          _infoRow(
            Icons.phone_outlined,
            'Phone',
            phone,
          ),

          _infoRow(
            Icons.location_on_outlined,
            'Address',
            address,
          ),

          _infoRow(
            Icons.inventory_2_outlined,
            'Quantity',
            '$quantity $unit',
          ),

          _infoRow(
            Icons.sell_outlined,
            'Price',
            'Rs. $price',
          ),

          _infoRow(
            Icons.access_time,
            'Order Date',
            _formatDate(createdAt),
          ),

          const SizedBox(
            height: 12,
          ),

          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.all(
              16,
            ),
            decoration:
            BoxDecoration(
              color:
              Colors.grey.shade100,
              borderRadius:
              BorderRadius.circular(
                14,
              ),
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
                Text(
                  'Rs. $totalPrice',
                  style:
                  const TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    primaryGreen,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          if (status == 'Pending')
            Row(
              children: [
                Expanded(
                  child:
                  ElevatedButton.icon(
                    onPressed: () =>
                        _confirmOrder(
                          doc.id,
                        ),
                    icon: const Icon(
                      Icons.check,
                    ),
                    label:
                    const Text(
                      'Confirm Order',
                    ),
                    style:
                    ElevatedButton
                        .styleFrom(
                      backgroundColor:
                      primaryGreen,
                      foregroundColor:
                      Colors.white,
                      padding:
                      const EdgeInsets
                          .symmetric(
                        vertical: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child:
                  OutlinedButton.icon(
                    onPressed: () =>
                        _cancelOrder(
                          doc.id,
                        ),
                    icon: const Icon(
                      Icons.close,
                    ),
                    label:
                    const Text(
                      'Cancel',
                    ),
                    style:
                    OutlinedButton
                        .styleFrom(
                      foregroundColor:
                      Colors.red,
                      side:
                      const BorderSide(
                        color: Colors.red,
                      ),
                      padding:
                      const EdgeInsets
                          .symmetric(
                        vertical: 13,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else if (status ==
              'Confirmed')
            SizedBox(
              width: double.infinity,
              child:
              ElevatedButton.icon(
                onPressed: () =>
                    _updateOrderStatus(
                      doc.id,
                      'Completed',
                    ),
                icon: const Icon(
                  Icons.done_all,
                ),
                label: const Text(
                  'Mark as Completed',
                ),
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  primaryGreen,
                  foregroundColor:
                  Colors.white,
                  padding:
                  const EdgeInsets
                      .symmetric(
                    vertical: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _infoRow(
    IconData icon,
    String title,
    String value,
    ) {
  return Padding(
    padding:
    const EdgeInsets.only(
      bottom: 10,
    ),
    child: Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: primaryGreen,
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 75,
          child: Text(
            title,
            style: TextStyle(
              color:
              Colors.grey.shade600,
              fontSize: 13,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildEmptyState() {
  return Center(
    child: Padding(
      padding:
      const EdgeInsets.all(30),
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 75,
            color:
            Colors.grey.shade400,
          ),
          const SizedBox(
            height: 18,
          ),
          const Text(
            'No Orders Found',
            style: TextStyle(
              fontSize: 22,
              fontWeight:
              FontWeight.bold,
              color: darkGreen,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            _selectedStatus == 'All'
                ? 'There are no customer orders yet.'
                : 'There are no $_selectedStatus orders.',
            textAlign:
            TextAlign.center,
            style: TextStyle(
              color:
              Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ),
  );
}
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  final String productName;
  final String category;
  final num price;
  final num stock;
  final String unit;

  const OrderScreen({
    super.key,
    required this.productName,
    required this.category,
    required this.price,
    required this.stock,
    required this.unit,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color lightGreen = Color(0xFFE8F5E9);

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final quantityController = TextEditingController(text: '1');

  bool isLoading = false;

  double get totalPrice {
    final quantity =
        double.tryParse(quantityController.text) ?? 0;

    return quantity * widget.price;
  }

  Future<void> placeOrder() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please login before placing an order.',
          ),
        ),
      );
      return;
    }

    final quantity =
        int.tryParse(quantityController.text.trim()) ?? 0;

    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid quantity.',
          ),
        ),
      );
      return;
    }

    if (quantity > widget.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Only ${widget.stock} ${widget.unit} available in stock.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .add({
        'userId': user.uid,
        'customerName':
        nameController.text.trim(),
        'phone':
        phoneController.text.trim(),
        'address':
        addressController.text.trim(),
        'productName':
        widget.productName,
        'category':
        widget.category,
        'price':
        widget.price,
        'quantity':
        quantity,
        'unit':
        widget.unit,
        'totalPrice':
        totalPrice,
        'status':
        'Pending',
        'createdAt':
        FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: primaryGreen,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Order Received',
                  ),
                ),
              ],
            ),
            content: const Text(
              'Your order has been submitted successfully.\n\n'
                  'Our shop owner will contact you to confirm the order.',
              style: TextStyle(
                height: 1.5,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Done'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to place order: ${e.message ?? e.code}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkGreen,
        elevation: 1,
        title: const Text(
          'Place Your Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            isMobile ? 18 : 35,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 650,
            ),
            child: Form(
              key: formKey,
              child: Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    isMobile ? 20 : 30,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // Product
                      Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.agriculture,
                              color: primaryGreen,
                              size: 38,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.productName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight:
                                FontWeight.bold,
                                color: darkGreen,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.category,
                              style: const TextStyle(
                                color: primaryGreen,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Price: Rs. ${widget.price}',
                              style: const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Available: ${widget.stock} ${widget.unit}',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Your Information',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        controller: nameController,
                        decoration:
                        const InputDecoration(
                          labelText: 'Farmer Name',
                          prefixIcon:
                          Icon(Icons.person_outline),
                          border:
                          OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter your name.';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller: phoneController,
                        keyboardType:
                        TextInputType.phone,
                        decoration:
                        const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '03XXXXXXXXX',
                          prefixIcon:
                          Icon(Icons.phone_outlined),
                          border:
                          OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter your phone number.';
                          }

                          if (value.trim().length <
                              10) {
                            return 'Please enter a valid phone number.';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller: addressController,
                        maxLines: 3,
                        decoration:
                        const InputDecoration(
                          labelText: 'Delivery Address',
                          prefixIcon:
                          Icon(Icons.location_on_outlined),
                          border:
                          OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter your address.';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        controller: quantityController,
                        keyboardType:
                        TextInputType.number,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration:
                        InputDecoration(
                          labelText:
                          'Quantity (${widget.unit})',
                          prefixIcon:
                          const Icon(
                            Icons.shopping_cart_outlined,
                          ),
                          border:
                          const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final quantity =
                          int.tryParse(
                            value?.trim() ?? '',
                          );

                          if (quantity == null ||
                              quantity <= 0) {
                            return 'Enter a valid quantity.';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Rs. ${totalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight:
                                FontWeight.bold,
                                color: primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                          isLoading
                              ? null
                              : placeOrder,
                          icon: isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Icon(
                            Icons.send,
                          ),
                          label: Text(
                            isLoading
                                ? 'Placing Order...'
                                : 'Place Order',
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
                              vertical: 15,
                            ),
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

                      const SizedBox(height: 18),

                      const Center(
                        child: Text(
                          'After placing the order, our shop owner will contact you for confirmation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
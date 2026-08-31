import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  bool isLoading = false;
  bool obscurePassword = true;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen = Color(0xFF2E7D32);

  static const Color darkGreen = Color(0xFF1B5E20);

  // ============================================================
  // REGISTER USER
  // ============================================================

  Future<void> registerUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phoneNumber = phoneController.text.trim();

    // ==========================================================
    // BASIC VALIDATION
    // ==========================================================

    if (email.isEmpty ||
        password.isEmpty ||
        phoneNumber.isEmpty) {
      _showMessage(
        'Please fill in all fields.',
      );
      return;
    }

    // ==========================================================
    // EMAIL VALIDATION
    // ==========================================================

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      _showMessage(
        'Please enter a valid email address.',
      );
      return;
    }

    // ==========================================================
    // PASSWORD VALIDATION
    // ==========================================================

    if (password.length < 6) {
      _showMessage(
        'Password must contain at least 6 characters.',
      );
      return;
    }

    // ==========================================================
    // PAKISTAN PHONE VALIDATION
    // ==========================================================

    final phoneRegex = RegExp(
      r'^03\d{9}$',
    );

    if (!phoneRegex.hasMatch(phoneNumber)) {
      _showMessage(
        'Enter a valid Pakistani phone number, e.g. 03001234567.',
      );
      return;
    }

    // ==========================================================
    // START LOADING
    // ==========================================================

    setState(() {
      isLoading = true;
    });

    try {
      // ========================================================
      // 1. CREATE FIREBASE AUTH ACCOUNT
      // ========================================================

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user == null) {
        throw Exception(
          'User account could not be created.',
        );
      }

      // ========================================================
      // 2. CREATE FARMER PROFILE IN FIRESTORE
      // ========================================================

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'email': email,
        'phoneNumber': phoneNumber,
        'role': 'farmer',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // ========================================================
      // SUCCESS MESSAGE
      // ========================================================

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully! Welcome to FarmerHub 🌾',
          ),
          backgroundColor: primaryGreen,
        ),
      );

      // ========================================================
      // GO TO HOME
      // ========================================================

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }

    // ==========================================================
    // FIREBASE AUTH ERRORS
    // ==========================================================

    on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message = 'Registration failed.';

      if (e.code == 'weak-password') {
        message = 'Password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'This email is already registered.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      } else if (e.code == 'network-request-failed') {
        message =
        'Network error. Please check your internet connection.';
      } else if (e.code == 'operation-not-allowed') {
        message =
        'Email/password registration is not enabled in Firebase.';
      }

      _showMessage(message);
    }

    // ==========================================================
    // FIREBASE / FIRESTORE ERRORS
    // ==========================================================

    on FirebaseException catch (e) {
      if (!mounted) return;

      _showMessage(
        'Something went wrong: '
            '${e.message ?? e.code}',
      );
    }

    // ==========================================================
    // OTHER ERRORS
    // ==========================================================

    catch (e) {
      if (!mounted) return;

      _showMessage(
        'Something went wrong: $e',
      );
    }

    // ==========================================================
    // STOP LOADING
    // ==========================================================

    finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      prefixIcon: Icon(
        icon,
        color: primaryGreen,
      ),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: Colors.grey.shade50,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: primaryGreen,
          width: 2,
        ),
      ),
    );
  }

  // ============================================================
  // BRAND HEADER
  // ============================================================

  Widget _brandHeader() {
    return Column(
      children: [
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                primaryGreen,
                darkGreen,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: const Icon(
            Icons.agriculture,
            color: Colors.white,
            size: 42,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Create Your Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Join FarmerHub and make your '
              'agricultural shopping easier.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // REGISTER FORM
  // ============================================================

  Widget _registerForm() {
    return Column(
      children: [
        _brandHeader(),

        const SizedBox(height: 35),

        // EMAIL
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          enableSuggestions: false,
          autocorrect: false,
          autofillHints: const [],
          decoration: _inputDecoration(
            label: 'Email Address',
            hint: 'Enter your email',
            icon: Icons.email_outlined,
          ),
        ),

        const SizedBox(height: 17),

        // PASSWORD
        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          enableSuggestions: false,
          autocorrect: false,
          autofillHints: const [],
          decoration: _inputDecoration(
            label: 'Password',
            hint: 'Create a password',
            icon: Icons.lock_outline,
            suffixIcon: IconButton(
              tooltip: obscurePassword
                  ? 'Show password'
                  : 'Hide password',
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 17),

        // PHONE
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: _inputDecoration(
            label: 'Phone Number',
            hint: '03001234567',
            icon: Icons.phone_outlined,
          ),
        ),

        const SizedBox(height: 25),

        // CREATE ACCOUNT BUTTON
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : registerUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
              Colors.grey.shade300,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: isLoading
                ? const SizedBox(
              width: 23,
              height: 23,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
                : const Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add_outlined,
                ),
                SizedBox(width: 9),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 22),

        // LOGIN LINK
        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account?',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                Navigator.pop(context);
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // SECURITY NOTE
        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 14,
              color: Colors.grey.shade500,
            ),

            const SizedBox(width: 6),

            Text(
              'Your information is securely stored.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final isMobile = width < 850;

    return Scaffold(
      backgroundColor:
      const Color(0xFFF6FAF7),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(
            Icons.arrow_back,
            color: darkGreen,
          ),
          onPressed: isLoading
              ? null
              : () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'FarmerHub',
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(
              isMobile ? 18 : 35,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1100,
              ),
              child: isMobile
                  ? Card(
                elevation: 3,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(24),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.all(24),
                  child: _registerForm(),
                ),
              )
                  : Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // LEFT FORM
                  Expanded(
                    flex: 5,
                    child: Card(
                      elevation: 4,
                      shadowColor:
                      Colors.black12,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          28,
                        ),
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.all(
                          42,
                        ),
                        child: _registerForm(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 25),

                  // RIGHT VISUAL
                  const Expanded(
                    flex: 4,
                    child:
                    _RegisterVisualWrapper(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

// ================================================================
// DESKTOP VISUAL WRAPPER
// ================================================================
class _RegisterVisualWrapper
    extends StatelessWidget {
  const _RegisterVisualWrapper();

  static const Color primaryGreen =
  Color(0xFF2E7D32);

  static const Color darkGreen =
  Color(0xFF1B5E20);

  Widget _featureBadge(
      IconData icon,
      String text,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),

          const SizedBox(width: 10),

          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 620,
        maxHeight: 620,
      ),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            darkGreen,
            primaryGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),

      child: Stack(
        children: [
          Positioned(
            top: 30,
            right: 25,
            child: Icon(
              Icons.grass,
              size: 110,
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
            ),
          ),

          Positioned(
            bottom: 25,
            left: 20,
            child: Icon(
              Icons.eco,
              size: 130,
              color: Colors.white.withValues(
                alpha: 0.08,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(35),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.15,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.agriculture,
                      size: 58,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Welcome to\nFarmerHub 🌾',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Quality agricultural products,\n'
                        'easy ordering, and better farming.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 35),

                  _featureBadge(
                    Icons.verified_outlined,
                    'Quality Products',
                  ),

                  const SizedBox(height: 12),

                  _featureBadge(
                    Icons.shopping_cart_outlined,
                    'Easy Ordering',
                  ),

                  const SizedBox(height: 12),

                  _featureBadge(
                    Icons.support_agent_outlined,
                    'Farmer Support',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
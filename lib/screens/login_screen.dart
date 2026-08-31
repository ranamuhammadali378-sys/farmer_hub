import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_products_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
// ============================================================
// CONTROLLERS
// ============================================================

final emailController = TextEditingController();
final passwordController = TextEditingController();

// ============================================================
// UI STATE
// ============================================================

bool isLoading = false;
bool obscurePassword = true;

// ============================================================
// COLORS
// ============================================================

static const Color primaryGreen = Color(0xFF2E7D32);
static const Color darkGreen = Color(0xFF1B5E20);
static const Color lightGreen = Color(0xFFE8F5E9);

// ============================================================
// OWNER UID
// ============================================================

static const String ownerUid =
'ePzpMjodHsQRE94OQsDS9kFGgvl1';

// ============================================================
// LOGIN
// ============================================================

Future<void> loginUser() async {
final email = emailController.text.trim();
final password = passwordController.text.trim();

// ----------------------------------------------------------
// BASIC VALIDATION
// ----------------------------------------------------------

if (email.isEmpty || password.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Please enter email and password.',
),
),
);
return;
}

setState(() {
isLoading = true;
});

try {
// --------------------------------------------------------
// FIREBASE LOGIN
// --------------------------------------------------------

final credential =
await FirebaseAuth.instance
.signInWithEmailAndPassword(
email: email,
password: password,
);

final user = credential.user;

if (user == null) {
throw Exception(
'Unable to get logged-in user.',
);
}

// --------------------------------------------------------
// DEBUG
// --------------------------------------------------------

debugPrint('================================');
debugPrint('LOGIN SUCCESS');
debugPrint('User Email: ${user.email}');
debugPrint('User UID: ${user.uid}');
debugPrint('Owner UID: $ownerUid');
debugPrint(
'Is Owner: ${user.uid == ownerUid}',
);
debugPrint('================================');

if (!mounted) return;

// --------------------------------------------------------
// OWNER
// --------------------------------------------------------

if (user.uid == ownerUid) {
Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) =>
const AdminProductsScreen(),
),
);
}

// --------------------------------------------------------
// FARMER / CUSTOMER
// --------------------------------------------------------

else {
Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) =>
const HomeScreen(),
),
);
}
}

// ==========================================================
// FIREBASE AUTH ERRORS
// ==========================================================

on FirebaseAuthException catch (e) {
debugPrint(
'Firebase Auth Error Code: ${e.code}',
);

debugPrint(
'Firebase Auth Error Message: ${e.message}',
);

if (!mounted) return;

String message = 'Login failed.';

if (e.code == 'invalid-credential') {
message =
'Invalid email or password.';
} else if (e.code == 'user-not-found') {
message =
'No account found with this email.';
} else if (e.code == 'wrong-password') {
message =
'Incorrect password.';
} else if (e.code == 'invalid-email') {
message =
'Please enter a valid email.';
} else if (e.code == 'too-many-requests') {
message =
'Too many attempts. Please try again later.';
} else if (e.code == 'network-request-failed') {
message =
'Network error. Please check your internet connection.';
}

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(message),
behavior: SnackBarBehavior.floating,
),
);
}

// ==========================================================
// OTHER ERRORS
// ==========================================================

catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
'Something went wrong: $e',
),
behavior: SnackBarBehavior.floating,
),
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
// REGISTER
// ============================================================

void openRegister() {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) =>
const RegisterScreen(),
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
super.dispose();
}

// ============================================================
// BUILD
// ============================================================

@override
Widget build(BuildContext context) {
final width =
MediaQuery.of(context).size.width;

final isMobile = width < 600;

return Scaffold(
backgroundColor: const Color(0xFFF6FAF7),

body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: EdgeInsets.symmetric(
horizontal: isMobile ? 20 : 30,
vertical: 30,
),

child: ConstrainedBox(
constraints:
const BoxConstraints(
maxWidth: 470,
),

child: Column(
children: [

// ==================================================
// BRAND HEADER
// ==================================================

Container(
width: double.infinity,
padding: EdgeInsets.symmetric(
vertical: isMobile ? 25 : 30,
horizontal: 20,
),

decoration: BoxDecoration(
gradient:
const LinearGradient(
colors: [
primaryGreen,
darkGreen,
],
begin:
Alignment.topLeft,
end:
Alignment.bottomRight,
),

borderRadius:
BorderRadius.circular(24),

boxShadow: const [
BoxShadow(
color: Colors.black12,
blurRadius: 20,
offset: Offset(0, 10),
),
],
),

child: Column(
children: [

// Logo
Container(
width: 78,
height: 78,

decoration:
BoxDecoration(
color: Colors.white,
shape: BoxShape.circle,

boxShadow: [
BoxShadow(
color: Colors.black
.withValues(
alpha: 0.12,
),
blurRadius: 12,
),
],
),

child: const Icon(
Icons.agriculture,
size: 42,
color: primaryGreen,
),
),

const SizedBox(height: 16),

const Text(
'FarmerHub',
style: TextStyle(
color: Colors.white,
fontSize: 28,
fontWeight:
FontWeight.bold,
letterSpacing: 0.5,
),
),

const SizedBox(height: 6),

const Text(
'Agriculture made easier 🌾',
style: TextStyle(
color: Colors.white70,
fontSize: 14,
),
),
],
),
),

const SizedBox(height: 22),

// ==================================================
// LOGIN CARD
// ==================================================

Card(
elevation: 5,

shadowColor:
Colors.black12,

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(24),
),

child: Padding(
padding: EdgeInsets.all(
isMobile ? 22 : 32,
),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [

// ------------------------------------------------
// TITLE
// ------------------------------------------------

const Text(
'Welcome Back',
style: TextStyle(
fontSize: 28,
fontWeight:
FontWeight.bold,
color: darkGreen,
),
),

const SizedBox(height: 7),

Text(
'Login to continue to your FarmerHub account.',
style: TextStyle(
fontSize: 14,
height: 1.5,
color:
Colors.grey.shade600,
),
),

const SizedBox(height: 28),

// ==================================================
// EMAIL
// ==================================================

const Text(
'Email Address',
style: TextStyle(
fontSize: 14,
fontWeight:
FontWeight.w600,
color: darkGreen,
),
),

const SizedBox(height: 8),

TextField(
controller:
emailController,

keyboardType:
TextInputType
.emailAddress,

enableSuggestions:
false,

autocorrect: false,

autofillHints: const [],

decoration:
InputDecoration(
hintText:
'Enter your email',

prefixIcon:
const Icon(
Icons
.email_outlined,
color:
primaryGreen,
),

filled: true,

fillColor:
lightGreen,

border:
OutlineInputBorder(
borderRadius:
BorderRadius
.circular(
14,
),
borderSide:
BorderSide
.none,
),

enabledBorder:
OutlineInputBorder(
borderRadius:
BorderRadius
.circular(
14,
),
borderSide:
BorderSide
.none,
),

focusedBorder:
OutlineInputBorder(
borderRadius:
BorderRadius
.circular(
14,
),
borderSide:
const BorderSide(
color:
primaryGreen,
width: 2,
),
),
),
),

const SizedBox(height: 20),

  // ==================================================
  // PASSWORD
  // ==================================================

  const Text(
    'Password',
    style: TextStyle(
      fontSize: 14,
      fontWeight:
      FontWeight.w600,
      color: darkGreen,
    ),
  ),

  const SizedBox(height: 8),

  TextField(
    controller:
    passwordController,

    obscureText:
    obscurePassword,

    enableSuggestions:
    false,

    autocorrect: false,

    autofillHints: const [],

    decoration:
    InputDecoration(
      hintText:
      'Enter your password',

      prefixIcon:
      const Icon(
        Icons
            .lock_outline,
        color:
        primaryGreen,
      ),

      suffixIcon:
      IconButton(
        tooltip:
        obscurePassword
            ? 'Show password'
            : 'Hide password',

        onPressed: () {
          setState(() {
            obscurePassword =
            !obscurePassword;
          });
        },

        icon: Icon(
          obscurePassword
              ? Icons
              .visibility_outlined
              : Icons
              .visibility_off_outlined,

          color:
          Colors.grey
              .shade600,
        ),
      ),

      filled: true,

      fillColor:
      lightGreen,

      border:
      OutlineInputBorder(
        borderRadius:
        BorderRadius
            .circular(
          14,
        ),
        borderSide:
        BorderSide
            .none,
      ),

      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius
            .circular(
          14,
        ),
        borderSide:
        BorderSide
            .none,
      ),

      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius
            .circular(
          14,
        ),
        borderSide:
        const BorderSide(
          color:
          primaryGreen,
          width: 2,
        ),
      ),
    ),
  ),

  const SizedBox(height: 28),

  // ==================================================
  // LOGIN BUTTON
  // ==================================================

  SizedBox(
    width:
    double.infinity,

    height: 54,

    child:
    ElevatedButton(
      onPressed:
      isLoading
          ? null
          : loginUser,

      style:
      ElevatedButton
          .styleFrom(
        backgroundColor:
        primaryGreen,

        foregroundColor:
        Colors.white,

        disabledBackgroundColor:
        Colors.grey
            .shade300,

        elevation: 2,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius
              .circular(
            14,
          ),
        ),
      ),

      child: isLoading
          ? const SizedBox(
        width: 24,
        height: 24,
        child:
        CircularProgressIndicator(
          strokeWidth: 2.5,
          color:
          Colors.white,
        ),
      )
          : const Row(
        mainAxisAlignment:
        MainAxisAlignment
            .center,
        children: [

          Icon(
            Icons
                .login,
            size: 20,
          ),

          SizedBox(
            width: 9,
          ),

          Text(
            'Login',
            style:
            TextStyle(
              fontSize:
              16,
              fontWeight:
              FontWeight
                  .bold,
            ),
          ),
        ],
      ),
    ),
  ),

  const SizedBox(height: 22),

  // ==================================================
  // DIVIDER
  // ==================================================

  Row(
    children: [
      Expanded(
        child:
        Divider(
          color: Colors
              .grey
              .shade300,
        ),
      ),

      Padding(
        padding:
        const EdgeInsets
            .symmetric(
          horizontal: 12,
        ),
        child: Text(
          'OR',
          style:
          TextStyle(
            fontSize: 12,
            fontWeight:
            FontWeight
                .w600,
            color: Colors
                .grey
                .shade500,
          ),
        ),
      ),

      Expanded(
        child:
        Divider(
          color: Colors
              .grey
              .shade300,
        ),
      ),
    ],
  ),

  const SizedBox(height: 20),

  // ==================================================
  // CREATE ACCOUNT
  // ==================================================

  SizedBox(
    width:
    double.infinity,

    height: 50,

    child:
    OutlinedButton.icon(
      onPressed:
      isLoading
          ? null
          : openRegister,

      icon:
      const Icon(
        Icons
            .person_add_outlined,
        size: 20,
      ),

      label: const Text(
        'Create New Account',
        style:
        TextStyle(
          fontWeight:
          FontWeight
              .w600,
        ),
      ),

      style:
      OutlinedButton
          .styleFrom(
        foregroundColor:
        primaryGreen,

        side:
        const BorderSide(
          color:
          primaryGreen,
          width: 1.3,
        ),

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius
              .circular(
            14,
          ),
        ),
      ),
    ),
  ),
],
),
),
),

  const SizedBox(height: 22),

  // ==================================================
  // FOOTER
  // ==================================================

  Text(
    'Trusted agriculture marketplace for farmers 🌱',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 12,
      color:
      Colors.grey.shade600,
    ),
  ),

  const SizedBox(height: 6),

  Text(
    '© 2026 FarmerHub',
    style: TextStyle(
      fontSize: 11,
      color:
      Colors.grey.shade500,
    ),
  ),
],
),
),
),
),
),
);
}
}
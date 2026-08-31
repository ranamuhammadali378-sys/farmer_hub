import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'agriculture_tools_screen.dart';
import '../core/responsive.dart';
import 'about_screen.dart';
import 'category_products.dart';
import 'login_screen.dart';
import 'products_screen.dart';

class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});

// =============================================================
// COLORS
// =============================================================

static const Color primaryGreen = Color(0xFF2E7D32);
static const Color darkGreen = Color(0xFF1B5E20);
static const Color lightGreen = Color(0xFFE8F5E9);

// =============================================================
// OPEN PRODUCTS
// =============================================================

void _openProducts(BuildContext context) {
final User? currentUser = FirebaseAuth.instance.currentUser;

if (currentUser == null) {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const LoginScreen(),
),
);
return;
}

Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const ProductsScreen(),
),
);
}

// =============================================================
// OPEN LOGIN
// =============================================================

void _openLogin(BuildContext context) {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const LoginScreen(),
),
);
}

// =============================================================
// LOGOUT
// =============================================================

Future<void> _logout(BuildContext context) async {
try {
await FirebaseAuth.instance.signOut();

if (!context.mounted) return;

Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(
builder: (context) => const LoginScreen(),
),
(route) => false,
);
} catch (e) {
if (!context.mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Logout failed: $e'),
),
);
}
}

// =============================================================
// CATEGORY CARD
// =============================================================

  Widget _categoryCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final bool mobile = Responsive.isMobile(context);

    return SizedBox(
      width: mobile ? double.infinity : 230,
      height: mobile ? 175 : 190,
      child: Card(
        elevation: 3,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap ??
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryProductsScreen(
                      category: title,
                      icon: icon,
                    ),
                  ),
                );
              },
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// =============================================================
// FEATURE ITEM
// =============================================================

Widget _featureItem({
required IconData icon,
required String title,
required String description,
}) {
return Container(
width: 220,
padding: const EdgeInsets.all(16),
child: Column(
children: [
Container(
padding: const EdgeInsets.all(13),
decoration: const BoxDecoration(
color: lightGreen,
shape: BoxShape.circle,
),
child: Icon(
icon,
color: primaryGreen,
size: 28,
),
),
const SizedBox(height: 12),
Text(
title,
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 6),
Text(
description,
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 13,
color: Colors.grey.shade600,
height: 1.4,
),
),
],
),
);
}

// =============================================================
// DESKTOP NAVIGATION
// =============================================================

Widget _desktopNavigation(
BuildContext context,
bool isLoggedIn,
) {
return Row(
mainAxisSize: MainAxisSize.min,
children: [
TextButton(
onPressed: () {},
child: const Text(
'Home',
style: TextStyle(
color: primaryGreen,
fontWeight: FontWeight.bold,
),
),
),
TextButton(
onPressed: () => _openProducts(context),
child: const Text('Products'),
),
TextButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const AboutScreen(),
),
);
},
child: const Text('About'),
),
const SizedBox(width: 10),
if (isLoggedIn)
ElevatedButton.icon(
onPressed: () => _logout(context),
icon: const Icon(
Icons.logout,
size: 18,
),
label: const Text('Logout'),
style: ElevatedButton.styleFrom(
backgroundColor: primaryGreen,
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(
horizontal: 18,
vertical: 12,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
),
)
else
ElevatedButton.icon(
onPressed: () => _openLogin(context),
icon: const Icon(
Icons.login,
size: 18,
),
label: const Text('Login'),
style: ElevatedButton.styleFrom(
backgroundColor: primaryGreen,
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(
horizontal: 18,
vertical: 12,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
),
),
const SizedBox(width: 25),
],
);
}

// =============================================================
// MOBILE DRAWER
// =============================================================

Widget _mobileDrawer(
BuildContext context,
bool isLoggedIn,
) {
return Drawer(
child: SafeArea(
child: Column(
children: [
Container(
width: double.infinity,
padding: const EdgeInsets.symmetric(
horizontal: 20,
vertical: 25,
),
decoration: const BoxDecoration(
color: lightGreen,
),
child: const Row(
children: [
Icon(
Icons.eco,
color: primaryGreen,
size: 34,
),
SizedBox(width: 10),
Text(
'FarmerHub',
style: TextStyle(
color: darkGreen,
fontSize: 23,
fontWeight: FontWeight.bold,
),
),
],
),
),

// HOME
ListTile(
leading: const Icon(
Icons.home_outlined,
color: primaryGreen,
),
title: const Text('Home'),
onTap: () {
Navigator.pop(context);
},
),

// PRODUCTS
ListTile(
leading: const Icon(
Icons.shopping_bag_outlined,
color: primaryGreen,
),
title: const Text('Products'),
onTap: () {
Navigator.pop(context);
_openProducts(context);
},
),

// ABOUT
ListTile(
leading: const Icon(
Icons.info_outline,
color: primaryGreen,
),
title: const Text('About'),
onTap: () {
Navigator.pop(context);

Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const AboutScreen(),
),
);
},
),

const Divider(),

// LOGIN / LOGOUT
Padding(
padding: const EdgeInsets.all(20),
child: SizedBox(
width: double.infinity,
child: ElevatedButton.icon(
onPressed: () {
Navigator.pop(context);

if (isLoggedIn) {
_logout(context);
} else {
_openLogin(context);
}
},
icon: Icon(
isLoggedIn
? Icons.logout
: Icons.login,
),
label: Text(
isLoggedIn ? 'Logout' : 'Login',
),
style: ElevatedButton.styleFrom(
backgroundColor: primaryGreen,
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(
vertical: 14,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
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
// BUILD
// =============================================================

@override
Widget build(BuildContext context) {
final bool mobile = Responsive.isMobile(context);

final double horizontalPadding =
Responsive.horizontalPadding(context);

final User? currentUser =
FirebaseAuth.instance.currentUser;

final bool isLoggedIn = currentUser != null;

return Scaffold(
backgroundColor: Colors.grey.shade50,

// =========================================================
// APP BAR
// =========================================================

appBar: AppBar(
elevation: 0,
backgroundColor: Colors.white,
surfaceTintColor: Colors.white,
title: const Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
Icons.eco,
color: primaryGreen,
size: 30,
),
SizedBox(width: 8),
Text(
'FarmerHub',
style: TextStyle(
color: darkGreen,
fontWeight: FontWeight.bold,
fontSize: 22,
),
),
],
),
actions: mobile
? [
Builder(
builder: (context) {
return IconButton(
tooltip: 'Menu',
icon: const Icon(
Icons.menu,
color: darkGreen,
),
onPressed: () {
Scaffold.of(context).openEndDrawer();
},
);
},
),
const SizedBox(width: 8),
]
: [
_desktopNavigation(
context,
isLoggedIn,
),
],
),

// =========================================================
// MOBILE DRAWER
// =========================================================

endDrawer: mobile
? _mobileDrawer(
context,
isLoggedIn,
)
: null,

// =========================================================
// BODY
// =========================================================

body: SingleChildScrollView(
child: Column(
children: [
// ===================================================
// HERO SECTION
// ===================================================

Container(
width: double.infinity,
padding: EdgeInsets.symmetric(
horizontal: horizontalPadding,
vertical: mobile ? 45 : 70,
),
decoration: const BoxDecoration(
gradient: LinearGradient(
colors: [
Color(0xFFE8F5E9),
Color(0xFFF8FFF8),
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
),
child: Center(
child: ConstrainedBox(
constraints: const BoxConstraints(
maxWidth: 1100,
),
child: mobile
? _mobileHero(context)
: _desktopHero(context),
),
),
),

// ===================================================
// CATEGORIES
// ===================================================

Padding(
padding: EdgeInsets.symmetric(
horizontal: horizontalPadding,
vertical: 55,
),
child: ConstrainedBox(
constraints: const BoxConstraints(
maxWidth: 1100,
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
const Text(
'Shop By Category',
style: TextStyle(
fontSize: 30,
fontWeight: FontWeight.bold,
color: darkGreen,
),
),
const SizedBox(height: 8),
Text(
'Find the agricultural products you need.',
style: TextStyle(
fontSize: 16,
color: Colors.grey.shade600,
),
),
const SizedBox(height: 25),

// CATEGORY CARDS
Wrap(
alignment: mobile
? WrapAlignment.center
: WrapAlignment.start,
spacing: 20,
runSpacing: 20,
children: [
// SEEDS
_categoryCard(
context: context,
icon: Icons.grass,
title: 'Seeds',
subtitle:
'Quality seeds for better crops',
),

// FERTILIZERS
_categoryCard(
context: context,
icon: Icons.science_outlined,
title: 'Fertilizers',
subtitle:
'Nutrition for healthy crops',
),

// PESTICIDES
_categoryCard(
context: context,
icon: Icons.shield_outlined,
title: 'Pesticides',
subtitle:
'Crop protection products',
),

// AGRICULTURAL TOOLS
  _categoryCard(
    context: context,
    icon: Icons.build_outlined,
    title: 'Agricultural Tools',
    subtitle: 'Tools for modern farming',
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AgricultureToolsScreen(),
        ),
      );
    },
  ),

// ANIMAL FEEDS
_categoryCard(
context: context,
icon: Icons.pets_outlined,
title: 'Animal Feeds',
subtitle:
'Quality feed for healthy animals',
),
],
),
],
),
),
),

// ===================================================
// WHY FARMERHUB
// ===================================================
  Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: 50,
    ),
    color: Colors.white,
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 1100,
      ),
      child: Column(
        children: [
          const Text(
            'Why Choose FarmerHub?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 35),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 15,
            runSpacing: 20,
            children: [
              _featureItem(
                icon: Icons.verified_outlined,
                title: 'Quality Products',
                description:
                'Reliable agricultural products for your farming needs.',
              ),
              _featureItem(
                icon: Icons.shopping_cart_outlined,
                title: 'Easy Ordering',
                description:
                'Select products and place your order with ease.',
              ),
              _featureItem(
                icon: Icons.phone_outlined,
                title: 'Direct Contact',
                description:
                'Get in touch with us for orders and support.',
              ),
              _featureItem(
                icon: Icons.agriculture_outlined,
                title: 'For Farmers',
                description:
                'Built specifically to make farming purchases easier.',
              ),
            ],
          ),
        ],
      ),
    ),
  ),

  // ===================================================
  // CALL TO ACTION
  // ===================================================

  Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: 50,
    ),
    child: Container(
      padding: EdgeInsets.all(
        mobile ? 25 : 40,
      ),
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(24),
      ),
      child: mobile
          ? Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Ready to order your farm supplies?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Create your FarmerHub account and start exploring agricultural products.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (isLoggedIn) {
                  _openProducts(context);
                } else {
                  _openLogin(context);
                }
              },
              icon: Icon(
                isLoggedIn
                    ? Icons.shopping_bag_outlined
                    : Icons.arrow_forward,
              ),
              label: Text(
                isLoggedIn
                    ? 'Explore Products'
                    : 'Get Started',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: darkGreen,
                padding:
                const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      )
          : Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to order your farm supplies?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Create your FarmerHub account and start exploring agricultural products.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),
          ElevatedButton.icon(
            onPressed: () {
              if (isLoggedIn) {
                _openProducts(context);
              } else {
                _openLogin(context);
              }
            },
            icon: Icon(
              isLoggedIn
                  ? Icons.shopping_bag_outlined
                  : Icons.arrow_forward,
            ),
            label: Text(
              isLoggedIn
                  ? 'Explore Products'
                  : 'Get Started',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: darkGreen,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ),
  ),

  // ===================================================
  // FOOTER
  // ===================================================

  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(25),
    color: const Color(0xFF102F12),
    child: const Column(
      children: [
        Text(
          'FarmerHub 🌾',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Making agriculture shopping easier for farmers.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '© 2026 FarmerHub. All rights reserved.',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    ),
  ),
],
),
),
);
}

  // =============================================================
  // DESKTOP HERO
  // =============================================================

  Widget _desktopHero(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _heroContent(context),
        ),
        const SizedBox(width: 50),
        Expanded(
          flex: 2,
          child: _heroVisual(),
        ),
      ],
    );
  }

  // =============================================================
  // MOBILE HERO
  // =============================================================

  Widget _mobileHero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heroContent(context),
        const SizedBox(height: 35),
        _heroVisual(),
      ],
    );
  }

  // =============================================================
  // HERO CONTENT
  // =============================================================

  Widget _heroContent(BuildContext context) {
    final bool mobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.agriculture,
                color: primaryGreen,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Your Trusted Agriculture Partner',
                style: TextStyle(
                  color: darkGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'Everything Farmers Need,\nIn One Place 🌾',
          style: TextStyle(
            fontSize: Responsive.titleSize(context),
            height: 1.15,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Discover quality agricultural products, '
              'choose what you need and place your order '
              'easily from FarmerHub.',
          style: TextStyle(
            fontSize: mobile ? 16 : 18,
            height: 1.6,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 30),

        // HERO BUTTONS
        mobile
            ? Column(
          crossAxisAlignment:
          CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () => _openProducts(context),
              icon: const Icon(
                Icons.shopping_bag_outlined,
              ),
              label: const Text(
                'Explore Products',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _openLogin(context),
              icon: const Icon(
                Icons.person_outline,
              ),
              label: const Text(
                'Join FarmerHub',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryGreen,
                side: const BorderSide(
                  color: primaryGreen,
                ),
                padding:
                const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        )
            : Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _openProducts(context),
              icon: const Icon(
                Icons.shopping_bag_outlined,
              ),
              label: const Text(
                'Explore Products',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 15),
            OutlinedButton.icon(
              onPressed: () => _openLogin(context),
              icon: const Icon(
                Icons.person_outline,
              ),
              label: const Text(
                'Join FarmerHub',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryGreen,
                side: const BorderSide(
                  color: primaryGreen,
                ),
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =============================================================
  // HERO VISUAL
  // =============================================================

  Widget _heroVisual() {
    return Container(
      width: double.infinity,
      height: 330,
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 25,
            right: 30,
            child: Icon(
              Icons.grass,
              size: 90,
              color: Colors.white.withValues(
                alpha: 0.15,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 25,
            child: Icon(
              Icons.eco,
              size: 110,
              color: Colors.white.withValues(
                alpha: 0.12,
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.agriculture,
                size: 95,
                color: Colors.white,
              ),
              SizedBox(height: 18),
              Text(
                'Grow Better.\nFarm Smarter.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
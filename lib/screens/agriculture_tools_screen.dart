import 'package:flutter/material.dart';

class AgricultureToolsScreen extends StatefulWidget {
  const AgricultureToolsScreen({super.key});

  @override
  State<AgricultureToolsScreen> createState() =>
      _AgricultureToolsScreenState();
}

class _AgricultureToolsScreenState
    extends State<AgricultureToolsScreen> {
static const Color primaryGreen = Color(0xFF2E7D32);
static const Color darkGreen = Color(0xFF1B5E20);
static const Color lightGreen = Color(0xFFE8F5E9);

final TextEditingController _searchController =
TextEditingController();

String _searchQuery = '';

final List<Map<String, dynamic>> _farmingTopics = [
{
'title': 'Smart Irrigation',
'subtitle': 'Use water efficiently and protect your crops.',
'icon': Icons.water_drop,
'tips': [
'Irrigate according to crop requirements and soil moisture.',
'Avoid unnecessary irrigation because excess water can damage roots.',
'Prefer early morning or evening irrigation when practical.',
'Check irrigation channels and pipes regularly for leakage.',
],
},
{
'title': 'Crop Planning',
'subtitle': 'Choose the right crop at the right time.',
'icon': Icons.grass,
'tips': [
'Consider soil type, climate and available irrigation.',
'Select varieties suitable for your local growing conditions.',
'Plan sowing according to the recommended crop season.',
'Use crop rotation to support long-term soil productivity.',
],
},
{
'title': 'Soil Health',
'subtitle': 'Healthy soil is the foundation of productive farming.',
'icon': Icons.landscape,
'tips': [
'Understand your soil before applying large amounts of fertilizer.',
'Maintain organic matter whenever possible.',
'Avoid excessive fertilizer application.',
'Monitor soil moisture and drainage.',
],
},
{
'title': 'Pest Management',
'subtitle': 'Protect crops through responsible pest management.',
'icon': Icons.bug_report,
'tips': [
'Inspect crops regularly for early signs of pests.',
'Identify the pest before selecting a control method.',
'Follow the pesticide label and recommended application rate.',
'Use integrated pest management practices where possible.',
],
},
{
'title': 'Plant Disease Care',
'subtitle': 'Identify symptoms early and protect crop health.',
'icon': Icons.eco,
'tips': [
'Check leaves, stems, roots and fruits regularly.',
'Remove severely affected plant material where appropriate.',
'Maintain suitable spacing and ventilation.',
'Use disease-control products only according to their labels.',
],
},
{
'title': 'Fertilizer Management',
'subtitle': 'Apply nutrients according to crop and soil needs.',
'icon': Icons.science,
'tips': [
'Avoid applying fertilizer without understanding crop requirements.',
'Use recommended doses and application methods.',
'Do not assume that more fertilizer always means more yield.',
'Keep fertilizer stored safely and away from children and animals.',
],
},
{
'title': 'Weather Awareness',
'subtitle': 'Make better farming decisions with weather information.',
'icon': Icons.wb_sunny,
'tips': [
'Check weather conditions before important field operations.',
'Avoid unnecessary spraying when rain is expected.',
'Protect sensitive crops during extreme weather conditions.',
'Plan irrigation according to rainfall and crop requirements.',
],
},
{
'title': 'Crop Monitoring',
'subtitle': 'Regular observation helps detect problems early.',
'icon': Icons.analytics,
'tips': [
'Walk through fields regularly instead of checking only one area.',
'Observe crop color, growth and leaf condition.',
'Record important observations during the crop season.',
'Compare crop development with expected growth stages.',
],
},
];

@override
void dispose() {
_searchController.dispose();
super.dispose();
}

List<Map<String, dynamic>> get _filteredTopics {
if (_searchQuery.trim().isEmpty) {
return _farmingTopics;
}

final query = _searchQuery.toLowerCase();

return _farmingTopics.where((topic) {
final title = topic['title'].toString().toLowerCase();
final subtitle =
topic['subtitle'].toString().toLowerCase();

final tips = (topic['tips'] as List)
.map((tip) => tip.toString().toLowerCase())
.join(' ');

return title.contains(query) ||
subtitle.contains(query) ||
tips.contains(query);
}).toList();
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
title: const Row(
children: [
Icon(
Icons.agriculture,
color: primaryGreen,
),
SizedBox(width: 10),
Text(
'Agriculture Tools',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
],
),
),
body: SafeArea(
child: SingleChildScrollView(
child: Center(
child: ConstrainedBox(
constraints: const BoxConstraints(
maxWidth: 1400,
),
child: Padding(
padding: EdgeInsets.all(
isMobile ? 16 : 30,
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
_buildHeroSection(isMobile),
const SizedBox(height: 25),
_buildSearchBar(),
const SizedBox(height: 30),
_buildSectionTitle(),
const SizedBox(height: 18),
_buildTopicGrid(width),
const SizedBox(height: 30),
_buildFarmerHubMessage(isMobile),
],
),
),
),
),
),
),
);
}

Widget _buildHeroSection(bool isMobile) {
return Container(
width: double.infinity,
padding: EdgeInsets.all(
isMobile ? 22 : 35,
),
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [
darkGreen,
primaryGreen,
],
),
borderRadius: BorderRadius.circular(24),
),
child: isMobile
? Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
_buildHeroIcon(),
const SizedBox(height: 18),
_buildHeroText(),
],
)
: Row(
children: [
_buildHeroIcon(),
const SizedBox(width: 25),
Expanded(
child: _buildHeroText(),
),
],
),
);
}

Widget _buildHeroIcon() {
return Container(
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: Colors.white.withValues(alpha: 0.15),
borderRadius: BorderRadius.circular(18),
),
child: const Icon(
Icons.agriculture,
size: 55,
color: Colors.white,
),
);
}

Widget _buildHeroText() {
return const Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
'Grow Smarter with Modern Farming',
style: TextStyle(
color: Colors.white,
fontSize: 28,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 10),
Text(
'FarmerHub provides practical agricultural guidance '
'to help farmers make better decisions, improve '
'crop management and use farm resources more efficiently.',
style: TextStyle(
color: Colors.white70,
fontSize: 15,
height: 1.5,
),
),
],
);
}

Widget _buildSearchBar() {
return TextField(
controller: _searchController,
onChanged: (value) {
setState(() {
_searchQuery = value;
});
},
decoration: InputDecoration(
hintText:
'Search farming topics, irrigation, soil, pests...',
prefixIcon: const Icon(
Icons.search,
color: primaryGreen,
),
suffixIcon: _searchQuery.isNotEmpty
? IconButton(
icon: const Icon(Icons.clear),
onPressed: () {
_searchController.clear();
setState(() {
_searchQuery = '';
});
},
)
: null,
filled: true,
fillColor: Colors.white,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: BorderSide(
color: Colors.grey.shade300,
),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: BorderSide(
color: Colors.grey.shade300,
),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: const BorderSide(
color: primaryGreen,
width: 2,
),
),
),
);
}

Widget _buildSectionTitle() {
return const Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Modern Farming Guide',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: darkGreen,
),
),
SizedBox(height: 5),
Text(
'Explore practical information for better farm management.',
style: TextStyle(
color: Colors.grey,
fontSize: 14,
),
),
],
);
}

Widget _buildTopicGrid(double width) {
final topics = _filteredTopics;

if (topics.isEmpty) {
return _buildNoResults();
}

int crossAxisCount;

if (width < 650) {
crossAxisCount = 1;
} else if (width < 950) {
crossAxisCount = 2;
} else if (width < 1250) {
crossAxisCount = 3;
} else {
crossAxisCount = 4;
}

return GridView.builder(
shrinkWrap: true,
physics:
const NeverScrollableScrollPhysics(),
itemCount: topics.length,
gridDelegate:
SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: crossAxisCount,
crossAxisSpacing: 18,
mainAxisSpacing: 18,
childAspectRatio:
width < 650 ? 1.45 : 1.05,
),
itemBuilder: (context, index) {
return _buildTopicCard(topics[index]);
},
);
}

Widget _buildTopicCard(
Map<String, dynamic> topic) {
final icon = topic['icon'] as IconData;

return Card(
elevation: 2,
shadowColor: Colors.black12,
color: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
),
child: InkWell(
borderRadius: BorderRadius.circular(20),
onTap: () {
_showTopicDetails(topic);
},
child: Padding(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
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
const SizedBox(height: 15),
Text(
topic['title'].toString(),
maxLines: 1,
overflow:
TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: darkGreen,
),
),
const SizedBox(height: 8),
Expanded(
child: Text(
topic['subtitle'].toString(),
maxLines: 3,
overflow:
TextOverflow.ellipsis,
style: TextStyle(
color: Colors.grey.shade600,
height: 1.4,
fontSize: 13,
),
),
),
const SizedBox(height: 10),
const Row(
children: [
Text(
'View guidance',
style: TextStyle(
color: primaryGreen,
fontWeight: FontWeight.bold,
fontSize: 13,
),
),
Spacer(),
Icon(
Icons.arrow_forward,
size: 18,
color: primaryGreen,
),
],
),
],
),
),
),
);
}

Widget _buildNoResults() {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(40),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
),
child: const Column(
children: [
Icon(
Icons.search_off,
size: 60,
color: Colors.grey,
),
SizedBox(height: 15),
Text(
'No farming topic found',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: darkGreen,
),
),
SizedBox(height: 6),
Text(
'Try searching for soil, irrigation, pests or crops.',
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.grey,
),
),
],
),
);
}

Widget _buildFarmerHubMessage(
bool isMobile) {
return Container(
width: double.infinity,
padding: EdgeInsets.all(
isMobile ? 22 : 30,
),
decoration: BoxDecoration(
color: lightGreen,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Colors.green.shade100,
),
),
child: const Row(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Icon(
Icons.verified,
color: primaryGreen,
size: 30,
),
SizedBox(width: 15),
Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
'Why FarmerHub?',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: darkGreen,
),
),
SizedBox(height: 7),
Text(
'FarmerHub is designed to make agricultural '
'shopping and farming information easier to access. '
'Farmers can explore products, understand basic '
'farming practices and make more informed decisions '
'from one convenient platform.',
style: TextStyle(
fontSize: 14,
height: 1.5,
color: Colors.black87,
),
),
],
),
),
],
),
);
}
void _showTopicDetails(
    Map<String, dynamic> topic) {
  final tips = topic['tips'] as List;
  final icon = topic['icon'] as IconData;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Row(
          children: [
            Container(
              padding:
              const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                topic['title'].toString(),
                style: const TextStyle(
                  color: darkGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 550,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  topic['subtitle'].toString(),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Practical Guidance',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 12),
                ...tips.map(
                      (tip) => Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 19,
                          color: primaryGreen,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            tip.toString(),
                            style: const TextStyle(
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                  const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: const Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Always follow local agricultural '
                              'recommendations and product labels '
                              'before applying agricultural inputs.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
}
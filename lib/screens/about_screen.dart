import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color primaryGreen =
  Color(0xFF2E7D32);

  static const Color darkGreen =
  Color(0xFF1B5E20);

  static const Color lightGreen =
  Color(0xFFE8F5E9);

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final bool mobile = width < 600;

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
              Icons.info_outline,
              color: primaryGreen,
            ),

            SizedBox(width: 10),

            Text(
              'About FarmerHub',
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // =================================================
            // HEADER
            // =================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal:
                mobile ? 25 : 70,
                vertical:
                mobile ? 45 : 70,
              ),
              decoration:
              const BoxDecoration(
                gradient:
                LinearGradient(
                  colors: [
                    lightGreen,
                    Color(0xFFF8FFF8),
                  ],
                  begin:
                  Alignment.topLeft,
                  end:
                  Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [

                  Container(
                    padding:
                    const EdgeInsets.all(18),
                    decoration:
                    const BoxDecoration(
                      color: primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child:
                    const Icon(
                      Icons.agriculture,
                      color:
                      Colors.white,
                      size: 55,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'FarmerHub',
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      darkGreen,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    'Your Trusted Agriculture Partner',
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      fontSize:
                      mobile ? 17 : 20,
                      color:
                      Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            // =================================================
            // ABOUT
            // =================================================

            Padding(
              padding:
              EdgeInsets.all(
                mobile ? 25 : 60,
              ),
              child:
              ConstrainedBox(
                constraints:
                const BoxConstraints(
                  maxWidth: 1000,
                ),
                child:
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [

                    const Text(
                      'About Us',
                      style:
                      TextStyle(
                        fontSize: 28,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        darkGreen,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Text(
                      'FarmerHub is an agriculture-focused platform designed to make it easier for farmers to discover and explore agricultural products.',
                      style:
                      TextStyle(
                        fontSize: 16,
                        height: 1.7,
                        color: Colors
                            .grey.shade700,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Text(
                      'Our goal is to connect farmers with quality seeds, fertilizers, pesticides, animal feed and useful agricultural resources through a simple and modern platform.',
                      style:
                      TextStyle(
                        fontSize: 16,
                        height: 1.7,
                        color: Colors
                            .grey.shade700,
                      ),
                    ),

                    const SizedBox(
                      height: 35,
                    ),

                    // =================================================
                    // MISSION
                    // =================================================

                    _infoCard(
                      icon:
                      Icons.flag_outlined,
                      title:
                      'Our Mission',
                      description:
                      'To make agricultural shopping and information easier, faster and more accessible for farmers.',
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    _infoCard(
                      icon:
                      Icons.verified_outlined,
                      title:
                      'Quality Products',
                      description:
                      'We aim to provide farmers with access to reliable agricultural products for their farming needs.',
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    _infoCard(
                      icon:
                      Icons.agriculture_outlined,
                      title:
                      'Built For Farmers',
                      description:
                      'FarmerHub is designed around the real needs of farmers and modern agriculture.',
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    // =================================================
                    // CATEGORIES
                    // =================================================

                    const Text(
                      'What You Can Find',
                      style:
                      TextStyle(
                        fontSize: 28,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        darkGreen,
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: const [

                        _CategoryInfo(
                          icon:
                          Icons.grass,
                          title:
                          'Seeds',
                        ),

                        _CategoryInfo(
                          icon:
                          Icons.science_outlined,
                          title:
                          'Fertilizers',
                        ),

                        _CategoryInfo(
                          icon:
                          Icons.shield_outlined,
                          title:
                          'Pesticides',
                        ),

                        _CategoryInfo(
                          icon:
                          Icons.pets_outlined,
                          title:
                          'Animal Feed',
                        ),

                        _CategoryInfo(
                          icon:
                          Icons.build_outlined,
                          title:
                          'Agricultural Tools',
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 45,
                    ),

                    // =================================================
                    // FOOTER MESSAGE
                    // =================================================

                    Container(
                      width:
                      double.infinity,
                      padding:
                      const EdgeInsets
                          .all(25),
                      decoration:
                      BoxDecoration(
                        color:
                        darkGreen,
                        borderRadius:
                        BorderRadius
                            .circular(
                            20),
                      ),
                      child:
                      const Column(
                        children: [

                          Icon(
                            Icons
                                .agriculture,
                            color:
                            Colors.white,
                            size: 40,
                          ),

                          SizedBox(
                            height: 12,
                          ),

                          Text(
                            'Growing Together 🌾',
                            textAlign:
                            TextAlign
                                .center,
                            style:
                            TextStyle(
                              color:
                              Colors.white,
                              fontSize: 24,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),

                          SizedBox(
                            height: 8,
                          ),

                          Text(
                            'Better products. Better information. Better farming.',
                            textAlign:
                            TextAlign
                                .center,
                            style:
                            TextStyle(
                              color:
                              Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // INFO CARD
  // =============================================================

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Container(
            padding:
            const EdgeInsets.all(12),
            decoration:
            BoxDecoration(
              color: lightGreen,
              borderRadius:
              BorderRadius.circular(
                  14),
            ),
            child: Icon(
              icon,
              color:
              primaryGreen,
              size: 30,
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
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
                  height: 6,
                ),

                Text(
                  description,
                  style:
                  TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors
                        .grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// CATEGORY INFO
// =============================================================

class _CategoryInfo
    extends StatelessWidget {

  final IconData icon;
  final String title;

  const _CategoryInfo({
    required this.icon,
    required this.title,
  });

  static const Color primaryGreen =
  Color(0xFF2E7D32);

  static const Color lightGreen =
  Color(0xFFE8F5E9);

  @override
  Widget build(
      BuildContext context) {
    return Container(
      width: 170,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [

          Container(
            padding:
            const EdgeInsets.all(12),
            decoration:
            const BoxDecoration(
              color: lightGreen,
              shape:
              BoxShape.circle,
            ),
            child: Icon(
              icon,
              color:
              primaryGreen,
              size: 30,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            title,
            textAlign:
            TextAlign.center,
            style:
            const TextStyle(
              fontWeight:
              FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
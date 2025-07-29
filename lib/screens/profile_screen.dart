import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fish_provider.dart';
import '../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.oceanGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Profile Avatar
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 30,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: AppTheme.primaryBlue,
                  ),
                ),

                const SizedBox(height: 20),

                // Username
                const Text(
                  'Fish Explorer',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Marine Life Enthusiast',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),

                // Statistics
                Consumer<FishProvider>(
                  builder: (context, fishProvider, child) {
                    final totalIdentifications = fishProvider.identifications.length;
                    final avgConfidence = totalIdentifications > 0
                        ? fishProvider.identifications
                                .map((i) => i.confidence)
                                .reduce((a, b) => a + b) /
                            totalIdentifications
                        : 0.0;
                    final uniqueSpecies = fishProvider.identifications
                        .map((i) => i.speciesName)
                        .toSet()
                        .length;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 10),
                            blurRadius: 30,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Your Statistics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkBlue,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(
                                'Total\nIdentifications',
                                totalIdentifications.toString(),
                                Icons.camera_alt,
                              ),
                              _buildStatItem(
                                'Unique\nSpecies',
                                uniqueSpecies.toString(),
                                Icons.pets,
                              ),
                              _buildStatItem(
                                'Avg\nConfidence',
                                '${(avgConfidence * 100).toStringAsFixed(0)}%',
                                Icons.trending_up,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Menu Items
                _buildMenuItem(
                  'Settings',
                   Icons.settings,
                   () => _showComingSoon(context),
                ),
                _buildMenuItem(
                  'Help & Support',
                  Icons.help,
                  () => _showHelpDialog(context),
                ),
                _buildMenuItem(
                  'About',
                  Icons.info,
                  () => _showAboutDialog(context),
                ),
                _buildMenuItem(
                  'Privacy Policy',
                  Icons.privacy_tip,
                  () => _showComingSoon(context),
                ),

                const SizedBox(height: 30),

                // App Version
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white70,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'What the Fish v1.0.0',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppTheme.lightBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryBlue,
            size: 30,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBlue,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            blurRadius: 15,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.lightBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryBlue,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkBlue,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: const Text('This feature will be available in a future update!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How to use the app:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('1. Use the Camera tab to take photos of fish'),
              Text('2. Or upload photos from your gallery'),
              Text('3. View identification results and details'),
              Text('4. Check your History to see past identifications'),
              Text('5. Explore marine life facts in the Explore tab'),
              SizedBox(height: 15),
              Text('For best results:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('• Focus clearly on the fish'),
              Text('• Use good lighting'),
              Text('• Get as close as possible'),
              Text('• Avoid blurry or dark images'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About What the Fish'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What the Fish is an AI-powered mobile app that helps you identify fish and aquatic animals from photos.',
                style: TextStyle(height: 1.4),
              ),
              SizedBox(height: 15),
              Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('• Real-time fish identification using AI'),
              Text('• Detailed species information'),
              Text('• History of identified fish'),
              Text('• Marine life facts and tips'),
              Text('• Offline access to saved results'),
              SizedBox(height: 15),
              Text('Version: 1.0.0'),
              Text('Powered by Google Gemini AI'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}


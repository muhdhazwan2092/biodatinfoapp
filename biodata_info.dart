import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A), // Darker, more elegant background
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildProfileCard(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: _buildQuoteCard(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildInfoRow(),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildContactSection(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Gradient header - fixed colors
        Container(
          height: 220,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A237E), // Deep Indigo
                Color(0xFF283593), // Dark Indigo
                Color(0xFF3949AB), // Indigo
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 40,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
              ),
              // Name & title - CENTERED
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const Text(
                      'Muhammad Hazwan Bin Ahri',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Flutter Developer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Profile picture
        Positioned(
          bottom: -50,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A237E),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3949AB).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 52,
              backgroundImage: AssetImage('assets/Gambar.jpeg'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E), // Dark card background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3949AB).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _profileRow(
            icon: Icons.cake_outlined,
            label: 'Date of Birth',
            value: '20 Sept 2003',
            iconColor: const Color(0xFF7986CB),
          ),
          _divider(),
          _profileRow(
            icon: Icons.location_on_outlined,
            label: 'State',
            value: 'Selangor, Malaysia',
            iconColor: const Color(0xFF7986CB),
          ),
          _divider(),
          _profileRow(
            icon: Icons.school_outlined,
            label: 'University',
            value: 'UPSI, Tanjung Malim',
            iconColor: const Color(0xFF7986CB),
          ),
          _divider(),
          _profileRow(
            icon: Icons.work_outline,
            label: 'Status',
            value: 'Final Year Student',
            iconColor: const Color(0xFF7986CB),
          ),
        ],
      ),
    );
  }

  Widget _profileRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: const Color(0xFF3949AB).withOpacity(0.2),
      height: 1,
      thickness: 1,
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF283593), // Dark Indigo
            Color(0xFF1A237E), // Deep Indigo
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"',
            style: TextStyle(
              fontSize: 60,
              height: 0.8,
              color: const Color(0xFF7986CB),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Make it work, make it right, make it fast.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 30,
                height: 2,
                color: const Color(0xFF7986CB),
              ),
              const SizedBox(width: 8),
              Text(
                'Muhd Hazwan',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF7986CB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        Expanded(
          child: _miniCard(
            icon: Icons.code,
            label: 'Projects',
            value: '5',
            iconColor: const Color(0xFF5C6BC0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _miniCard(
            icon: Icons.star_outline,
            label: 'GPA',
            value: '3.85',
            iconColor: const Color(0xFF7E57C2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _miniCard(
            icon: Icons.emoji_events_outlined,
            label: 'Awards',
            value: '3',
            iconColor: const Color(0xFFEC407A),
          ),
        ),
      ],
    );
  }

  Widget _miniCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3949AB).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONTACT',
            style: TextStyle(
              fontSize: 11,
              color: const Color(0xFF7986CB),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          _contactRow(
            icon: Icons.email_outlined,
            label: 'muhdhazwan363@gmail.com',
            color: const Color(0xFF64B5F6),
          ),
          const SizedBox(height: 12),
          _contactRow(
            icon: Icons.phone_outlined,
            label: '+60 18 284 0658',
            color: const Color(0xFF81C784),
          ),
          const SizedBox(height: 12),
          _contactRow(
            icon: Icons.language,
            label: 'github.com/muhdhazwan363',
            color: const Color(0xFF9575CD),
          ),
          const SizedBox(height: 12),
          _contactRow(
            icon: Icons.telegram,
            label: '@muhdhazwan363',
            color: const Color(0xFF4FC3F7),
          ),
        ],
      ),
    );
  }

  Widget _contactRow({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
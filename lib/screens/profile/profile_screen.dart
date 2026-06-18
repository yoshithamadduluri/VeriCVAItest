import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/github_service.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _githubController = TextEditingController();
  final GitHubService _gitHubService = GitHubService();
  final UserService _userService = UserService();
  
  bool _isVerifying = false;
  Map<String, int>? _verifiedSkills;

  User? _authUser;
  Map<String, dynamic>? _userProfile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoadingProfile = true);
    
    final authUser = _userService.getCurrentAuthUser();
    final userProfile = await _userService.getUserProfile();
    
    if (mounted) {
      setState(() {
        _authUser = authUser;
        _userProfile = userProfile;
        _isLoadingProfile = false;
      });
    }
  }

  void _verifyGitHub() async {
    final username = _githubController.text.trim();
    if (username.isEmpty) return;

    setState(() {
      _isVerifying = true;
    });

    try {
      final languageCounts = await _gitHubService.analyzeUserLanguages(username);
      
      setState(() {
        _isVerifying = false;
        _verifiedSkills = languageCounts;
      });
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GitHub skills verified successfully!')),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: $e')),
        );
      }
    }
  }

  void _handleLogout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await AuthService().signOut();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  void dispose() {
    _githubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Verification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoadingProfile)
              const Center(child: CircularProgressIndicator())
            else ...[
              _buildProfileHeader(),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
            ],
            Text(
              'Skill Verification (GitHub)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Connect your GitHub account to verify your claimed programming skills based on your public repositories.',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _githubController,
                    decoration: const InputDecoration(
                      hintText: 'Enter GitHub Username',
                      prefixIcon: Icon(Icons.code),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyGitHub,
                  child: _isVerifying
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Verify'),
                ),
              ],
            ),
            if (_verifiedSkills != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Verified Languages:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._verifiedSkills!.entries.map((entry) {
                // Calculate basic confidence
                double confidence = _gitHubService.calculateSkillConfidence(entry.key, _verifiedSkills!);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(entry.key),
                    subtitle: Text('Found in ${entry.value} repositories'),
                    trailing: Chip(
                      label: Text('${confidence.toInt()}% Confidence'),
                      backgroundColor: confidence > 80 ? Colors.green[100] : Colors.orange[100],
                    ),
                  ),
                );
              }),
            ],
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Portfolio Authenticity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.link),
              title: const Text('Link Portfolio Project'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement Portfolio Verification
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final name = _authUser?.displayName ?? _userProfile?['name'] ?? 'User Name';
    final email = _authUser?.email ?? _userProfile?['email'] ?? 'No Email';
    final photoUrl = _authUser?.photoURL ?? _userProfile?['photoUrl'];
    final provider = _userProfile?['provider'] ?? 'Password';
    final uid = _authUser?.uid ?? 'Unknown ID';
    
    String createdAtStr = 'N/A';
    if (_userProfile?['createdAt'] != null) {
      final Timestamp ts = _userProfile!['createdAt'] as Timestamp;
      createdAtStr = ts.toDate().toLocal().toString().split('.')[0]; // YYYY-MM-DD HH:MM:SS
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blueAccent,
          backgroundImage: photoUrl != null && photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
          child: photoUrl == null || photoUrl.isEmpty ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
        ),
        const SizedBox(height: 16),
        Text(
          name.isNotEmpty ? name : 'User',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInfoRow('Provider', provider.toUpperCase()),
                const Divider(),
                _buildInfoRow('User ID', uid),
                const Divider(),
                _buildInfoRow('Account Created', createdAtStr),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

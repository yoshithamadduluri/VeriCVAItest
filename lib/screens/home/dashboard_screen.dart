import 'package:flutter/material.dart';
import '../resume/resume_upload_screen.dart';
import '../interview/mock_interview_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    _HomeDashboard(),
    ResumeUploadScreen(),
    MockInterviewScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VeriCV AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.document_scanner_outlined),
            selectedIcon: Icon(Icons.document_scanner),
            label: 'Resume',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_none),
            selectedIcon: Icon(Icons.mic),
            label: 'Interviews',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back, User!',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          const Card(
            child: ListTile(
              leading: Icon(Icons.score, size: 40, color: Colors.blue),
              title: Text('Resume Trust Score'),
              subtitle: Text('85% - Excellent'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.work, size: 40, color: Colors.green),
              title: Text('Job Match Score'),
              subtitle: Text('Upload job description to check'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.code, size: 40, color: Colors.orange),
              title: Text('GitHub Skill Verification'),
              subtitle: Text('Verified 5 skills'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}



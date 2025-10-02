import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF1E88E5),
                ),
                accountName: Text(
                  user?.name ?? 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(user?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    (user?.name ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                subtitle: Text(user?.phone ?? ''),
                onTap: () {
                  Navigator.of(context).pop();
                  // Navigate to profile screen if implemented
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Call History'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Navigate to history screen if implemented
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Navigate to settings screen if implemented
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: () {
                  Navigator.of(context).pop();
                  showAboutDialog(
                    context: context,
                    applicationName: 'Get Calley',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(Icons.call, size: 48),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
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
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/language',
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

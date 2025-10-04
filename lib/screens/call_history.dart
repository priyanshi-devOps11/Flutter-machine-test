import 'package:flutter/material.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<CallRecord> _calls = [
    CallRecord(
      name: 'Rajesh Kumar',
      number: '+91 98765 43210',
      time: '10:30 AM',
      duration: '5m 23s',
      status: CallStatus.completed,
      date: 'Today',
    ),
    CallRecord(
      name: 'Priya Sharma',
      number: '+91 98765 43211',
      time: '09:15 AM',
      duration: '2m 10s',
      status: CallStatus.completed,
      date: 'Today',
    ),
    CallRecord(
      name: 'Amit Patel',
      number: '+91 98765 43212',
      time: 'Yesterday',
      duration: '0m 00s',
      status: CallStatus.missed,
      date: 'Yesterday',
    ),
    CallRecord(
      name: 'Sneha Reddy',
      number: '+91 98765 43213',
      time: 'Yesterday',
      duration: '8m 45s',
      status: CallStatus.completed,
      date: 'Yesterday',
    ),
    CallRecord(
      name: 'Vikram Singh',
      number: '+91 98765 43214',
      time: '2 days ago',
      duration: '3m 56s',
      status: CallStatus.completed,
      date: 'Jan 2',
    ),
    CallRecord(
      name: 'Anita Desai',
      number: '+91 98765 43215',
      time: '2 days ago',
      duration: '0m 00s',
      status: CallStatus.missed,
      date: 'Jan 2',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Call History',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.black54, size: 20),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile')),
              );
            },
          ),
          IconButton(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications,
                  color: Colors.black54, size: 20),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search calls...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Stats Cards
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.call,
                    count: '248',
                    label: 'Completed',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.phone_missed,
                    count: '12',
                    label: 'Missed',
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.phone_callback,
                    count: '35',
                    label: 'Today',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          // Call List
          Expanded(
            child: ListView.builder(
              itemCount: _calls.length,
              itemBuilder: (context, index) {
                final call = _calls[index];
                final showDateHeader =
                    index == 0 || _calls[index - 1].date != call.date;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          call.date,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: call.status == CallStatus.missed
                                ? Colors.red[50]
                                : Colors.green[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            call.status == CallStatus.missed
                                ? Icons.phone_missed
                                : Icons.call,
                            color: call.status == CallStatus.missed
                                ? Colors.red[600]
                                : Colors.green[600],
                            size: 20,
                          ),
                        ),
                        title: Text(
                          call.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          call.number,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              call.time,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              call.duration,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey[100],
                      indent: 76,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color.shade700,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, false, () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }),
          _buildNavItem(Icons.image, false, () {}),
          Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4B7BF5),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4B7BF5).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
              onPressed: () {},
            ),
          ),
          _buildNavItem(Icons.phone, true, () {}),
          _buildNavItem(Icons.calendar_today, false, () {}),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, VoidCallback onTap) {
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? const Color(0xFF4B7BF5) : Colors.grey[400],
        size: 24,
      ),
      onPressed: onTap,
    );
  }
}

extension on Color {
  get shade700 => null;

  get shade600 => null;
}

enum CallStatus { completed, missed }

class CallRecord {
  final String name;
  final String number;
  final String time;
  final String duration;
  final CallStatus status;
  final String date;

  CallRecord({
    required this.name,
    required this.number,
    required this.time,
    required this.duration,
    required this.status,
    required this.date,
  });
}

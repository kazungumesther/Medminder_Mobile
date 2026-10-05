import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/medicine.dart';

class HistoryScreen extends StatelessWidget {
  final List<HistoryLog> intakeHistory;
  final bool isLoading;
  final VoidCallback onNavigateToDashboard;
  final VoidCallback onNavigateToToAddMedicine;
  final VoidCallback onNavigateToProfile;
  final VoidCallback onLogoutTrigger;

  const HistoryScreen({
    super.key,
    required this.intakeHistory,
    required this.isLoading,
    required this.onNavigateToDashboard,
    required this.onNavigateToToAddMedicine,
    required this.onNavigateToProfile,
    required this.onLogoutTrigger,
  });

  String _formatTimestamp(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "Just now";
    try {
      final DateTime date = DateTime.parse(isoString).toLocal();
      return DateFormat('MMM d, hh:mm a').format(date);
    } catch (e) {
      return "Just now"; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) onNavigateToDashboard();
          if (index == 1) onNavigateToToAddMedicine();
          if (index == 2) {} 
          if (index == 3) onNavigateToProfile(); 
          if (index == 4) onLogoutTrigger();
        },
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF94A3B8),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 16,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_rounded), label: 'Add Med'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.logout_rounded), label: 'Logout'),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: Text('Loading tracking history...', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(color: Color(0xFFE6F0FA), shape: BoxShape.circle),
                          child: const Icon(Icons.history_edu_rounded, color: Color(0xFF1A73E8), size: 22),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Medicine History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                              SizedBox(height: 4),
                              Text('Here are the medicines you have taken.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: intakeHistory.isEmpty
                        ? const Center(child: Text('No medicines have been taken yet.', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            itemCount: intakeHistory.length,
                            itemBuilder: (context, index) {
                              final log = intakeHistory[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle_outline, color: Color(0xFF1A73E8), size: 20),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(log.action.isNotEmpty ? log.action : 'MEDICINE LOGGED', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                            const SizedBox(height: 4),
                                            RichText(
                                              text: TextSpan(
                                                style: const TextStyle(fontSize: 12, color: Colors.black87),
                                                children: [
                                                  const TextSpan(text: 'ID Reference: ', style: TextStyle(color: Color(0xFF64748B))),
                                                  TextSpan(text: log.medicationId, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF64748B)),
                                            const SizedBox(width: 4),
                                            Text(_formatTimestamp(log.timestamp), style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(20)),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.check_rounded, color: Color(0xFF059669), size: 12),
                                              SizedBox(width: 4),
                                              Text('Completed', style: TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}

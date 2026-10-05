import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine.dart';

class HomeScreen extends StatefulWidget {
  final List<Medicine> medications;
  final Function(String) onToggleCheck;
  final VoidCallback onAddReminderTrigger;
  final VoidCallback onLogoutTrigger;
  final VoidCallback onHistoryTrigger;
  final VoidCallback onProfileTrigger;

  const HomeScreen({
    super.key,
    required this.medications,
    required this.onToggleCheck,
    required this.onAddReminderTrigger,
    required this.onLogoutTrigger,
    required this.onHistoryTrigger,
    required this.onProfileTrigger,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeNavIndex = 0;
  String _headerProfileName = "Medicine User";
  String _headerProfileInitials = "MU";

  @override
  void initState() {
    super.initState();
    _loadLiveHeaderBadgeCredentials();
  }

  Future<void> _loadLiveHeaderBadgeCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedName = prefs.getString('session_user_name') ?? "Medicine User";
    
    String initials = "MU";
    final List<String> parts = savedName.trim().toUpperCase().split(" ");
    if (parts.length >= 2) {
      initials = parts[0].substring(0, 1) + parts[1].substring(0, 1);
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      initials = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1);
    }

    if (mounted) {
      setState(() {
        _headerProfileName = savedName;
        _headerProfileInitials = initials;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalCount = widget.medications.length;
    final int takenCount = widget.medications.where((m) => m.taken == true).length;
    final int remainingCount = totalCount - takenCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeNavIndex,
        onTap: (index) {
          setState(() => _activeNavIndex = index);
          if (index == 1) widget.onAddReminderTrigger();
          if (index == 2) widget.onHistoryTrigger();
          if (index == 3) widget.onProfileTrigger();
          if (index == 4) widget.onLogoutTrigger();
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWideScreen = constraints.maxWidth > 850;

            return Padding(
              padding: EdgeInsets.all(isWideScreen ? 32.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Good morning!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          SizedBox(height: 2),
                          Text('Here is your medicine schedule for today.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: const Color(0xFF2563EB),
                              child: Text(_headerProfileInitials, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                            const SizedBox(width: 8),
                            Text(_headerProfileName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildSummaryCard('Medicines', '$totalCount', 'Total Added', Colors.blue, Icons.medication)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSummaryCard('Taken', '$takenCount', 'Completed', Colors.green, Icons.check_circle_outline)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSummaryCard('Upcoming', '$remainingCount', 'Remaining', Colors.redAccent, Icons.access_time)),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Today\'s Medicines', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      GestureDetector(
                        onTap: widget.onAddReminderTrigger,
                        child: const Text('+ Add Medicine', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      itemCount: widget.medications.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWideScreen ? 3 : (constraints.maxWidth > 550 ? 2 : 1),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: isWideScreen ? 1.45 : 1.65,
                      ),
                      itemBuilder: (context, idx) {
                        final med = widget.medications[idx];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.01), offset: const Offset(0, 4), blurRadius: 10),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)),
                                    child: const Icon(Icons.medication, color: Color(0xFF2563EB), size: 16),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          med.name,
                                          style: TextStyle(
                                            fontSize: 14, 
                                            fontWeight: FontWeight.bold, 
                                            color: const Color(0xFF0F172A), 
                                            decoration: med.taken ? TextDecoration.lineThrough : null
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(med.strength, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  _buildWebRowDetail(Icons.access_time, 'Time:', med.time),
                                  const SizedBox(height: 4),
                                  _buildWebRowDetail(Icons.autorenew, 'Frequency:', 'Once a day'),
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: () => widget.onToggleCheck(med.id),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: med.taken ? const Color(0xFF10B981) : const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text(med.taken ? '✓ Taken' : 'Take', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String mainValue, String sub, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 6),
          Text(mainValue, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildWebRowDetail(IconData icon, String label, String val) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(width: 4),
        Text(val, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
      ],
    );
  }
}

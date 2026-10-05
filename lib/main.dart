import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'viewmodel/medication_viewmodel.dart';
import 'services/notification_service.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add-medicine_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MedMinderApp());
}

class MedMinderApp extends StatelessWidget {
  const MedMinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedMinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
      ),
      home: const ApplicationShellRouter(),
    );
  }
}

class ApplicationShellRouter extends StatefulWidget {
  const ApplicationShellRouter({super.key});

  @override
  State<ApplicationShellRouter> createState() => _ApplicationShellRouterState();
}

class _ApplicationShellRouterState extends State<ApplicationShellRouter> {
  String _activeViewRoute = 'onboarding';
  final MedicationViewModel _viewModel = MedicationViewModel();

  @override
  void initState() {
    super.initState();
    _checkPersistedUserSession();
    NotificationService().initializeNotificationEngine();
    _viewModel.addListener(_onViewModelStateChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelStateChanged);
    super.dispose();
  }

  Future<void> _checkPersistedUserSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final String? email = prefs.getString('session_user_email');

    if (isLoggedIn && email != null && mounted) {
      await _viewModel.initializeUserContextSession(email);
      setState(() {
        _activeViewRoute = 'dashboard';
      });
    }
  }

  Future<void> _saveUserSession(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('session_user_email', email);
  }

  Future<void> _clearUserSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    _viewModel.clearActiveSessionStateContext();
  }

  void _onViewModelStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _renderActiveScreenLayer(),
        ),
      ),
    );
  }

  Widget _renderActiveScreenLayer() {
    switch (_activeViewRoute) {
      case 'onboarding':
        return WelcomeScreen(
          onForwardTrigger: () => setState(() => _activeViewRoute = 'auth'),
        );

      case 'auth':
        return AuthScreen(
          onAuthSuccessTrigger: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            final String currentEmail =
                prefs.getString('session_user_email') ?? 'user@medminder.com';
            await _saveUserSession(currentEmail);
            await _viewModel.initializeUserContextSession(currentEmail);
            setState(() => _activeViewRoute = 'dashboard');
          },
          onCancelTrigger: () =>
              setState(() => _activeViewRoute = 'onboarding'),
        );

      case 'dashboard':
        return HomeScreen(
          medications: _viewModel.medications,
          onToggleCheck: (String id) =>
              _viewModel.toggleMedicationTakenState(id),
          onAddReminderTrigger: () =>
              setState(() => _activeViewRoute = 'add-medicine'),
          onLogoutTrigger: () async {
            await _clearUserSession();
            setState(() => _activeViewRoute = 'onboarding');
          },
          onHistoryTrigger: () => setState(() => _activeViewRoute = 'history'),
          onProfileTrigger: () => setState(() => _activeViewRoute = 'profile'),
        );

      case 'profile':
        return ProfileScreen(
          onNavigateToDashboard: () =>
              setState(() => _activeViewRoute = 'dashboard'),
          onNavigateToHistory: () =>
              setState(() => _activeViewRoute = 'history'),
          onNavigateToAddMedicine: () =>
              setState(() => _activeViewRoute = 'add-medicine'),
          onLogoutTrigger: () async {
            await _clearUserSession();
            setState(() => _activeViewRoute = 'onboarding');
          },
        );

      case 'history':
        return HistoryScreen(
          intakeHistory: _viewModel.historyLogs,
          isLoading: _viewModel.isLoading,
          onNavigateToDashboard: () =>
              setState(() => _activeViewRoute = 'dashboard'),
          onNavigateToToAddMedicine: () =>
              setState(() => _activeViewRoute = 'add-medicine'),
          onNavigateToProfile: () =>
              setState(() => _activeViewRoute = 'profile'),
          onLogoutTrigger: () async {
            await _clearUserSession();
            setState(() => _activeViewRoute = 'onboarding');
          },
        );

      case 'add-medicine':
        return AddMedicineScreen(
          onSaveTrigger: (name, strength, time) async {
            final conflictWarning = await _viewModel.addNewMedicationRecord(
              name,
              strength,
              time,
            );
            if (conflictWarning == null) {
              setState(() => _activeViewRoute = 'dashboard');
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Safety Interaction Warning'),
                  content: Text(conflictWarning),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Review Entry'),
                    ),
                  ],
                ),
              );
            }
          },
          onCancelTrigger: () => setState(() => _activeViewRoute = 'dashboard'),
        );

      default:
        return WelcomeScreen(
          onForwardTrigger: () => setState(() => _activeViewRoute = 'auth'),
        );
    }
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:med_minder_app/viewmodel/medication_viewmodel.dart';

void main() {
  final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();

  const String testUserEmail = "sandbox.user@example.com";

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/flutter_local_notifications'),
      (MethodCall methodCall) async => null,

    );
    
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('://dexterous.com'),
      (MethodCall methodCall) async => null,
    );
  });

  group('MedMinder Architecture Validation Suite', () {
    test('Verify initialization updates context and loads records empty on fresh boot', () async {
      final viewModel = MedicationViewModel();
      
      expect(viewModel.medications.isEmpty, true);
      expect(viewModel.historyLogs.isEmpty, true);
      expect(viewModel.isLoading, true);
    });

    test('Verify custom entries update state layout items dynamically', () async {
      final viewModel = MedicationViewModel();
      
      await viewModel.initializeUserContextSession(testUserEmail);
      await viewModel.addNewMedicationRecord("PARACETAMOL", "500mg", "12:00 PM");

      expect(viewModel.medications.length, 1);
      expect(viewModel.medications.first.name, "PARACETAMOL");
      expect(viewModel.medications.first.taken, false);
    });

    test('Verify toggle taken logs automated lock-screen tracking items', () async {
      final viewModel = MedicationViewModel();
      
      await viewModel.initializeUserContextSession(testUserEmail);
      await viewModel.addNewMedicationRecord("PANADOL", "500mg", "06:00 PM");
      
      final String targetId = viewModel.medications.first.id;
      await viewModel.toggleMedicationTakenState(targetId);

      expect(viewModel.medications.first.taken, true);
      expect(viewModel.historyLogs.length, 1);
      expect(viewModel.historyLogs.first.action, "PANADOL");
    });
  });
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine.dart';
import '../services/notification_service.dart';

class MedicationViewModel extends ChangeNotifier {
  final String _backendUrl = "https://medminder-api-2e8p.onrender.com";

  List<Medicine> _medications = [];
  List<HistoryLog> _historyLogs = [];
  bool _isLoading = true;
  String _currentSessionEmail = "";

  List<Medicine> get medications => _medications;
  List<HistoryLog> get historyLogs => _historyLogs;
  bool get isLoading => _isLoading;

  Future<void> initializeUserContextSession(String email) async {
    _currentSessionEmail = email.trim().toLowerCase();
    await fetchDatabaseRecords();
  }

  void clearActiveSessionStateContext() {
    _medications = [];
    _historyLogs = [];
    _currentSessionEmail = "";
    notifyListeners();
  }

  Future<void> fetchDatabaseRecords() async {
    _isLoading = true;
    notifyListeners();

    await _loadRecordsFromLocalCache();

    if (_currentSessionEmail.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final medResponse = await http
          .get(Uri.parse('$_backendUrl/medications'))
          .timeout(const Duration(seconds: 4));
      final historyResponse = await http
          .get(Uri.parse('$_backendUrl/api/history'))
          .timeout(const Duration(seconds: 4));

      if (medResponse.statusCode == 200 && historyResponse.statusCode == 200) {
        final List<dynamic> medData = json.decode(medResponse.body);
        final List<dynamic> historyData = json.decode(historyResponse.body);

        _medications = medData.map((item) => Medicine.fromJson(item)).toList();
        _historyLogs = historyData
            .map((item) => HistoryLog.fromJson(item))
            .toList();
        await _saveRecordsToLocalCache();
      }
    } catch (error) {
      print(
        "Network connection timeout, reading isolated profile disk rows: $error",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleMedicationTakenState(String id) async {
    final targetIndex = _medications.indexWhere((m) => m.id == id);
    if (targetIndex == -1) return;

    final bool nextTakenState = !_medications[targetIndex].taken;
    final currentMed = _medications[targetIndex];

    _medications[targetIndex] = Medicine(
      id: currentMed.id,
      name: currentMed.name,
      strength: currentMed.strength,
      time: currentMed.time,
      taken: nextTakenState,
    );

    if (nextTakenState) {
      final newHistoryLog = HistoryLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        medicationId: currentMed.id,
        action: currentMed.name.toUpperCase(),
        timestamp: DateTime.now().toUtc().toIso8601String(),
      );
      _historyLogs.insert(0, newHistoryLog);

      NotificationService().sendInstantMedicationAlert(
        "MedMinder Intake Logged! ",
        "Successfully tracked your daily dose of ${currentMed.name} (${currentMed.strength}) at ${currentMed.time}.",
      );
    } else {
      _historyLogs.removeWhere((log) => log.medicationId == currentMed.id);
    }

    notifyListeners();
    await _saveRecordsToLocalCache();

    try {
      await http.patch(
        Uri.parse('$_backendUrl/api/medicines/$id'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'taken': nextTakenState}),
      );
    } catch (error) {
      print("Background database toggle processing fault: $error");
    }
  }

  Future<String?> addNewMedicationRecord(
    String name,
    String strength,
    String time,
  ) async {
    final newMedicine = Medicine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.toUpperCase(),
      strength: strength,
      time: time,
      taken: false,
    );

    _medications.add(newMedicine);
    notifyListeners();
    await _saveRecordsToLocalCache();

    NotificationService().sendInstantMedicationAlert(
      "New Reminder Programmed! 🗓️",
      "Successfully registered ${name.toUpperCase()} ($strength) to your daily active matrix at $time.",
    );

    try {
      final response = await http
          .post(
            Uri.parse('$_backendUrl/api/medicines'),
            headers: {"Content-Type": "application/json"},
            body: json.encode(newMedicine.toJson()),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 409) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        return errorData['detail'] ??
            'Medication interaction conflict detected.';
      }
    } catch (error) {
      print("Background database registration processing fault: $error");
    }
    return null;
  }

  Future<void> _saveRecordsToLocalCache() async {
    if (_currentSessionEmail.isEmpty) return;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> encodedMeds = _medications
          .map((m) => json.encode(m.toJson()))
          .toList();
      final List<String> encodedLogs = _historyLogs
          .map(
            (l) => json.encode({
              'id': l.id,
              'medicationId': l.medicationId,
              'action': l.action,
              'timestamp': l.timestamp,
            }),
          )
          .toList();

      await prefs.setStringList(
        'meds_profile_key_$_currentSessionEmail',
        encodedMeds,
      );
      await prefs.setStringList(
        'logs_profile_key_$_currentSessionEmail',
        encodedLogs,
      );
    } catch (e) {
      print("Cache state encryption write fault: $e");
    }
  }

  Future<void> _loadRecordsFromLocalCache() async {
    if (_currentSessionEmail.isEmpty) return;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? encodedMeds = prefs.getStringList(
        'meds_profile_key_$_currentSessionEmail',
      );
      final List<String>? encodedLogs = prefs.getStringList(
        'logs_profile_key_$_currentSessionEmail',
      );

      if (encodedMeds != null) {
        _medications = encodedMeds
            .map((m) => Medicine.fromJson(json.decode(m)))
            .toList();
      } else {
        _medications = [];
      }

      if (encodedLogs != null) {
        _historyLogs = encodedLogs.map((l) {
          final decoded = json.decode(l);
          return HistoryLog(
            id: decoded['id'] ?? '',
            medicationId: decoded['medicationId'] ?? '',
            action: decoded['action'] ?? '',
            timestamp: decoded['timestamp'] ?? '',
          );
        }).toList();
      } else {
        _historyLogs = [];
      }
    } catch (e) {
      print("Cache state decryption load fault: $e");
    }
  }
}

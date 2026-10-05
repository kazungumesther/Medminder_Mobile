import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medicine.dart';
import 'medication_api.dart';

class MedicationService {
  final String _backendUrl = "https://medminder-api-2e8p.onrender.com";

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final String targetEndpoint = "$_backendUrl/api/auth/login";
    final Map<String, String> payloadData = {
      "email": email.trim(),
      "password": password,
    };

    try {
      final response = await http.post(
        Uri.parse(targetEndpoint),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(payloadData),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": responseData['message'] ?? 'Login successful.',
          "user": responseData['user'],
        };
      } else {
        return {
          "success": false,
          "message":
              responseData['detail'] ??
              responseData['message'] ??
              'Invalid credentials.',
        };
      }
    } catch (error) {
      print("Service Login connection fault: $error");
      return {
        "success": false,
        "message":
            "Could not contact the database server. Please check your network.",
      };
    }
  }

  Future<Map<String, dynamic>> registerUser(
    String name,
    String email,
    String password,
  ) async {
    final String targetEndpoint = "$_backendUrl/api/auth/register";
    final Map<String, String> payloadData = {
      "name": name.trim(),
      "email": email.trim(),
      "password": password,
    };

    try {
      final response = await http.post(
        Uri.parse(targetEndpoint),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(payloadData),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": responseData['message'] ?? 'Registration successful.',
        };
      } else {
        return {
          "success": false,
          "message":
              responseData['detail'] ??
              responseData['message'] ??
              'Registration failed.',
        };
      }
    } catch (error) {
      print("Service Registration connection fault: $error");
      return {
        "success": false,
        "message":
            "Could not contact the database server. Please check your network.",
      };
    }
  }

  Future<List<Medicine>> getMedications() async {
    final response = await http.get(
      Uri.parse(MedicationApi.medicationsEndpoint),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Medicine.fromJson(item)).toList();
    }
    throw Exception('Failed to load active medications from server database.');
  }

  Future<List<HistoryLog>> getHistoryLogs() async {
    final response = await http.get(Uri.parse(MedicationApi.historyEndpoint));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => HistoryLog.fromJson(item)).toList();
    }
    throw Exception('Failed to load historical intake record timelines.');
  }

  Future<bool> patchMedicationTakenState(String id, bool takenState) async {
    final response = await http.patch(
      Uri.parse('${MedicationApi.medicationsEndpoint}/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'taken': takenState}),
    );
    return response.statusCode == 200;
  }

  Future<String?> postNewMedication(Medicine medicine) async {
    final response = await http.post(
      Uri.parse(MedicationApi.medicationsEndpoint),
      headers: {"Content-Type": "application/json"},
      body: json.encode(medicine.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return null;
    } else if (response.statusCode == 409) {
      final Map<String, dynamic> errorData = json.decode(response.body);
      return errorData['detail'] ?? 'Medical interaction conflict detected.';
    }
    throw Exception(
      'Server returned error status code: ${response.statusCode}',
    );
  }
}

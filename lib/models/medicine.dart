class Medicine {
  final String id;
  final String name;
  final String strength;
  final String time;
  final bool taken;

  Medicine({
    required this.id,
    required this.name,
    required this.strength,
    required this.time,
    required this.taken,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      strength: json['dosage']?.toString() ?? json['strength']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      taken: json['taken'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': strength,
      'time': time,
      'frequency': 'Once a day',
      'taken': taken,
    };
  }
}

class HistoryLog {
  final String id;
  final String medicationId;
  final String action;
  final String timestamp;

  HistoryLog({
    required this.id,
    required this.medicationId,
    required this.action,
    required this.timestamp,
  });

  factory HistoryLog.fromJson(Map<String, dynamic> json) {
    return HistoryLog(
      id: json['id']?.toString() ?? '',
      medicationId: json['medicationId']?.toString() ??
          json['medication_id']?.toString() ??
          json['medication']?['id']?.toString() ??
          '',
      action: json['action']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ??
          json['createdAt']?.toString() ??
          json['created_at']?.toString() ??
          '',
    );
  }
}

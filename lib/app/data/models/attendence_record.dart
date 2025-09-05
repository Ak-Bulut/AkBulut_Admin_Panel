enum EventType { entry, exit, unknown }

class AttendanceRecord {
  final String userId;
  final String cardName;
  final DateTime createTime;
  final EventType type;
  final String? snapshotUrl; // Resim URL'si olabilir

  AttendanceRecord({
    required this.userId,
    required this.cardName,
    required this.createTime,
    required this.type,
    this.snapshotUrl,
  });
}

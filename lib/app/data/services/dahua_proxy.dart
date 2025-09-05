// import 'package:akbulut_admin/app/data/models/attendence_record.dart'; // Bu satır kendi projenize göre doğru olsun
// import 'package:http/http.dart' as http; // Sadece bu paket yeterli

// class DahuaService {
//   // Artık direkt Dahua'ya değil, bilgisayarımızdaki aracıya istek atıyoruz
//   final String _proxyBaseUrl = "http://localhost:3000/api/records";

//   Future<List<AttendanceRecord>> fetchAttendanceRecords(DateTime startTime, DateTime endTime) async {
//     final int startTimestamp = startTime.millisecondsSinceEpoch ~/ 1000;
//     final int endTimestamp = endTime.millisecondsSinceEpoch ~/ 1000;

//     final url = '$_proxyBaseUrl?StartTime=$startTimestamp&EndTime=$endTimestamp';

//     try {
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         return _parseResponse(response.body);
//       } else {
//         throw Exception('Aracıdan (Proxy) Hata Geldi: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Aracıya bağlanılamadı. Terminalde "node proxy.js" çalışıyor mu?');
//     }
//   }

//   // BU FONKSİYON AYNI KALIYOR
//   List<AttendanceRecord> _parseResponse(String responseBody) {
//     final lines = responseBody.split('\n');
//     final Map<int, Map<String, String>> recordsMap = {};
//     for (final line in lines) {
//       final parts = line.split('=');
//       if (parts.length < 2) continue;
//       final keyPart = parts[0];
//       final value = parts.sublist(1).join('=').trim();
//       final keyParts = keyPart.replaceAll(']', '').split(RegExp(r'\[|\.'));
//       if (keyParts.length == 3 && keyParts[0] == 'records') {
//         final index = int.parse(keyParts[1]);
//         final key = keyParts[2];

//         recordsMap.putIfAbsent(index, () => {});
//         recordsMap[index]![key] = value;
//       }
//     }

//     final List<AttendanceRecord> attendanceRecords = [];
//     recordsMap.forEach((index, data) {
//       try {
//         final record = AttendanceRecord(
//           userId: data['UserID'] ?? 'unknown',
//           cardName: data['CardName'] ?? 'N/A',
//           createTime: DateTime.fromMillisecondsSinceEpoch((int.parse(data['CreateTime'] ?? '0')) * 1000),
//           type: (data['Type'] == 'Entry') ? EventType.entry : EventType.unknown,
//           snapshotUrl: data.containsKey('URL') && data['URL']!.isNotEmpty ? data['URL'] : null,
//         );
//         attendanceRecords.add(record);
//       } catch (e) {
//         print("Parsing error for record $index: $e");
//       }
//     });

//     attendanceRecords.sort((a, b) => b.createTime.compareTo(a.createTime));
//     return attendanceRecords;
//   }
// }

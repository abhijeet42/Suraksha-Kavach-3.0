import 'dart:convert';

class QrPayload {
  final String familyId;
  final String adminName;
  final String ipAddress;
  final int port;

  QrPayload({
    required this.familyId,
    required this.adminName,
    required this.ipAddress,
    required this.port,
  });

  Map<String, dynamic> toMap() {
    return {
      'fid': familyId,
      'name': adminName,
      'ip': ipAddress,
      'p': port,
    };
  }

  factory QrPayload.fromMap(Map<String, dynamic> map) {
    return QrPayload(
      familyId: map['fid'] ?? '',
      adminName: map['name'] ?? '',
      ipAddress: map['ip'] ?? '',
      port: map['p'] ?? 8080,
    );
  }

  String toJson() => json.encode(toMap());

  factory QrPayload.fromJson(String source) => QrPayload.fromMap(json.decode(source));
}

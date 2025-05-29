import 'package:flutter_sns_app/domain/entities/report.dart';

class ReportDto {
  String id;
  String reason;
  String type;

  ReportDto({required this.id, required this.reason, required this.type});

  factory ReportDto.fromEntity(Report report) {
    return ReportDto(id: report.id, reason: report.reason, type: report.type);
  }

  Map<String, dynamic> toFirestore() {
    return {'id': id, 'reason': reason, 'type': type};
  }
}

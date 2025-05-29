import 'package:flutter_sns_app/domain/entities/report.dart';
import 'package:flutter_sns_app/domain/repositories/report_repository.dart';

class SendReportUsecase {
  final ReportRepository repository;

  SendReportUsecase(this.repository);

  Future<bool> execute({
    required String id,
    required String reason,
    required String type,
  }) {
    return repository.saveReport(
      Report(id: id, reason: reason, type: type),
    );
  }
}

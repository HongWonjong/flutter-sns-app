import 'package:flutter_sns_app/data/datasources/report_remote_datasource.dart';
import 'package:flutter_sns_app/data/dtos/report_dto.dart';
import 'package:flutter_sns_app/domain/entities/report.dart';
import 'package:flutter_sns_app/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository{
  final ReportRemoteDatasource _dataSource;

  ReportRepositoryImpl(this._dataSource);

  @override
  Future<bool> saveReport(Report report) async {
    final response  = _dataSource.saveReport(ReportDto.fromEntity(report));
    return response;
  }
}
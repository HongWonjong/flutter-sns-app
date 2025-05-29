import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/data/datasources/report_remote_datasource.dart';
import 'package:flutter_sns_app/data/repositories/report_repository_impl.dart';
import 'package:flutter_sns_app/domain/repositories/report_repository.dart';
import 'package:flutter_sns_app/domain/usecases/send_report_usecase.dart';

final reportRemoteDataSourceProvider = Provider<ReportRemoteDatasource>((ref) {
  return ReportRemoteDatasource();
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(ref.watch(reportRemoteDataSourceProvider));
});


final sendReportUsecase = Provider<SendReportUsecase>((ref) {
  return SendReportUsecase(ref.watch(reportRepositoryProvider));
});
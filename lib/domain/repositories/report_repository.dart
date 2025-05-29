

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/domain/entities/report.dart';

abstract class ReportRepository {
  Future<bool> saveReport(Report report);
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/data/dtos/report_dto.dart';
import 'package:flutter_sns_app/services/firebase_firestore_service.dart';

class ReportRemoteDatasource {
  final FirebaseFirestore _firestore;

  ReportRemoteDatasource() : _firestore = FirebaseFirestoreService().firestore;

  Future<bool> saveReport(ReportDto reportDto) async {
    try {
      await _firestore
          .collection('reports')
          .doc(reportDto.id)
          .set(reportDto.toFirestore());
      return true;
    } catch (e) {
      print('Failed to save report: $e');
      return false;
    }
  }
}

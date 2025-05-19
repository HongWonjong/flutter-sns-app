import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  static final FirebaseFirestoreService _instance = FirebaseFirestoreService._internal();
  final FirebaseFirestore _firestore;

  factory FirebaseFirestoreService() {
    return _instance;
  }

  FirebaseFirestoreService._internal() : _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;
}
// lib/core/test_data_generator.dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/services/firebase_firestore_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_sns_app/data/datasources/storage_datasource.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class TestDataGenerator {
  final FirebaseFirestoreService _firestoreService;
  final StorageDataSource _storageDataSource;

  TestDataGenerator(this._firestoreService, this._storageDataSource);

  Future<File> _createVirtualImage() async {
    // 200x200 크기의 파란색 배경 이미지 생성
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, const ui.Rect.fromLTWH(0, 0, 200, 200));

    // 파란색 배경
    final paint = ui.Paint()..color = const ui.Color.fromRGBO(0, 0, 255, 1.0);
    canvas.drawRect(const ui.Rect.fromLTWH(0, 0, 200, 200), paint);

    final picture = recorder.endRecording();
    final uiImage = await picture.toImage(200, 200);
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    // img 패키지로 PNG 데이터를 디코딩
    final image = img.decodePng(buffer)!;

    // 임시 파일로 저장
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/virtual_image.png');
    await tempFile.writeAsBytes(img.encodePng(image));

    return tempFile;
  }

  Future<void> generateTestData() async {
    final firestore = _firestoreService.firestore;
    const sampleTexts = [
      '난..오늘도 눈물을 흘린다..',
      '슬픔을 느낄 수 있다는 건 좋은거야..',
      '오늘은 기분이 좋아!',
      '하늘을 바라보며 생각에 잠긴다..',
      '너와 함께한 시간들이 떠올라..',
      '이 순간을 기억하고 싶어.',
      '커피 한 잔이 필요해..',
      '비가 오는 날엔 따뜻한 차 한 잔.',
      '꿈을 꾸는 게 두려워..',
      '너무 피곤한 하루였어.',
      '오늘도 열심히 살아보자!',
      '햇살이 따뜻해서 기분 좋아.',
      '가끔은 혼자 있고 싶어..',
      '친구들과 함께한 시간, 최고야.',
      '새로운 시작을 준비 중!',
      '책을 읽으며 힐링 중..',
      '운동 후 상쾌한 기분!',
      '저녁 노을이 너무 예뻐..',
      '음악을 들으며 걷는 중.',
      '오늘 하루도 수고했어.',
    ];

    const sampleTags = [
      ['#오늘', '#감정'],
      ['#슬픔', '#생각'],
      ['#기쁨', '#일상'],
      ['#하늘', '#명상'],
      ['#추억', '#너'],
      ['#기억', '#순간'],
      ['#커피', '#여유'],
      ['#비', '#차'],
      ['#꿈', '#두려움'],
      ['#피곤', '#하루'],
      ['#노력', '#오늘'],
      ['#햇살', '#기분'],
      ['#혼자', '#생각'],
      ['#친구', '#행복'],
      ['#새로운', '#시작'],
      ['#책', '#힐링'],
      ['#운동', '#상쾌'],
      ['#노을', '#저녁'],
      ['#음악', '#산책'],
      ['#수고', '#하루'],
    ];

    final existingPosts = await firestore.collection('posts').get();
    final startIndex = existingPosts.docs.length;

    // 가상 이미지 생성
    File virtualImage;
    try {
      virtualImage = await _createVirtualImage();
    } catch (e) {
      print('가상 이미지 생성 실패: $e');
      throw Exception('가상 이미지 생성 실패');
    }

    for (int i = 0; i < 5; i++) {
      final index = (startIndex + i) % sampleTexts.length;
      final postId = Uuid().v4();
      final createdAt = DateTime.now().toIso8601String();

      // 가상 이미지를 Firebase Storage에 업로드
      String imageUrl;
      try {
        imageUrl = await _storageDataSource.uploadImage(postId, virtualImage);
        print('이미지 업로드 성공: $imageUrl');
      } catch (e) {
        print('이미지 업로드 실패: $e');
        throw Exception('이미지 업로드 실패');
      }

      await firestore.collection('posts').doc(postId).set({
        'postId': postId,
        'imageUrl': imageUrl,
        'text': sampleTexts[index],
        'tags': sampleTags[index],
        'createdAt': createdAt,
      });

      final comment1Id = Uuid().v4();
      final comment2Id = Uuid().v4();
      await firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(comment1Id)
          .set({
        'commentId': comment1Id,
        'text': '수요일은 피곤해서',
        'createdAt': DateTime.now()
            .subtract(Duration(minutes: 10))
            .toIso8601String(),
      });
      await firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(comment2Id)
          .set({
        'commentId': comment2Id,
        'text': '희요일은 화가나서',
        'createdAt': DateTime.now().toIso8601String(),
      });
    }

    // 모든 게시물 생성 후 임시 파일 삭제
    await virtualImage.delete();
  }
}

---

# 📚 Firebase 데이터베이스 및 스토리지 구조

## 🌟 개요
이 문서는 Firebase Firestore와 Firebase Storage를 사용한 데이터베이스 구조를 정의합니다. 앱은 게시물 목록 조회(무한 스크롤), 게시물 작성, 댓글 보기/작성을 지원합니다. 

---

## 🔥 Firestore 데이터베이스 구조

#### **문서 데이터**
```json
/posts/post1
{
  "postId": "post1", // Firestore 문서 ID, 실제로는 uuid
  "imageUrl": "https://firebasestorage.googleapis.com/v0/b/your-app.appspot.com/o/images%2Fpost1%2Fpost1.jpg?alt=media",
  "text": "난..오늘도 눈물을 흘린 다.",
  "tags": ["#태그명", "#감정"], // 태그 리스트, List<String> 형식
  "createdAt": "2025-05-16T15:22:00+09:00"
}

/posts/post2
{
  "postId": "post2", // Firestore 문서 ID, 실제로는 uuid
  "imageUrl": "https://firebasestorage.googleapis.com/v0/b/your-app.appspot.com/o/images%2Fpost2%2Fpost2.jpg?alt=media",
  "text": "슬픔을 느낄 수 있다는 건 좋은거야..",
  "tags": ["#태그명", "#감정"], // 태그 리스트, List<String> 형식
  "createdAt": "2025-05-16T15:23:00+09:00"
}
```

#### **필드 상세**
- `postId`: Firestore 문서 ID, UUID로 생성.
- `imageUrl`: Firebase Storage에 저장된 이미지 URL.
- `text`: 게시물 내용, 최대 200자.
- `tag`: 게시물 분류용 해시태그 (예: "#태그명").
- `createdAt`: 작성 시간, ISO 8601 형식 (KST 기준).

---

### 💬 2. Comments 서브컬렉션

#### **문서 데이터**
```json
/posts/post1/comments/comment1
{
  "commentId": "comment1", // Firestore 문서 ID, 실제로는 uuid
  "text": "수요일은 피곤해서",
  "createdAt": "2025-05-16T15:24:00+09:00"
}

/posts/post1/comments/comment2
{
  "commentId": "comment2", // Firestore 문서 ID, 실제로는 uuid
  "text": "희요일은 화가나서",
  "createdAt": "2025-05-16T15:24:30+09:00"
}
```

#### **필드 상세**
- `commentId`: Firestore 문서 ID, UUID로 생성.
- `text`: 댓글 내용, 짧은 텍스트로 가정.
- `createdAt`: 작성 시간, ISO 8601 형식 (KST 기준).

---

## 📦 Firebase Storage 구조
Firebase Storage는 게시물 이미지를 저장하며, Firestore의 `imageUrl` 필드에 저장된 URL을 통해 접근합니다.

### **Storage 경로**
- `images/{postId}/{imageName}`
    - `PUT images/{postId}/{imageName}` # 이미지 업로드 (Storage의 `upload` 메서드 사용)
    - `GET images/{postId}/{imageName}` # 이미지 URL 가져오기 (Storage의 `getDownloadURL` 메서드 사용)

#### **파일 데이터**
```json
images/post1/post1.jpg
{
  "fileName": "post1.jpg",
  "path": "images/post1/post1.jpg",
  "url": "https://firebasestorage.googleapis.com/v0/b/your-app.appspot.com/o/images%2Fpost1%2Fpost1.jpg?alt=media"
}

images/post2/post2.jpg
{
  "fileName": "post2.jpg",
  "path": "images/post2/post2.jpg",
  "url": "https://firebasestorage.googleapis.com/v0/b/your-app.appspot.com/o/images%2Fpost2%2Fpost2.jpg?alt=media"
}
```

#### **설명**
- `images/`: 게시물 이미지를 저장하는 최상위 폴더.
- `{postId}/`: 각 게시물별 하위 폴더 (예: `post1`).
- `{imageName}`: 이미지 파일명 (예: `post1.jpg`).
- `url`: Firestore의 `imageUrl` 필드에 저장되어 앱에서 사용.

---

## 🔗 Firestore와 Storage 연계
- **게시물 작성 (PostCreatePage)**:
    1. 이미지를 `images/{postId}/`에 업로드.
    2. 업로드된 이미지의 URL을 가져옴 (`getDownloadURL`).
    3. `/posts`에 새 문서 생성, `imageUrl` 필드에 URL 저장.
- **게시물 목록 (PostListPage)**:
    - `/posts`에서 게시물 목록 조회.
    - `imageUrl`로 Storage에서 이미지 표시.
- **댓글 페이지 (CommentPage)**:
    - `/posts/{postId}/comments`에서 댓글 목록 조회 및 작성.

---

## 📝 요약
- **Firestore**:
    - `/posts/{postId}`: 게시물 데이터 (`postId`, `imageUrl`, `text`, `tag`, `createdAt`).
        - `GET /posts/{postId}` # 특정 게시물 조회
        - `GET /posts` # 게시물 목록 조회
        - `POST /posts` # 게시물 작성
    - `/posts/{postId}/comments/{commentId}`: 댓글 데이터 (`commentId`, `text`, `createdAt`).
        - `GET /posts/{postId}/comments` # 댓글 목록 조회
        - `POST /posts/{postId}/comments` # 댓글 작성
- **Storage**:
    - `images/{postId}/{imageName}`: 게시물 이미지 파일.
        - `PUT images/{postId}/{imageName}` # 이미지 업로드
        - `GET images/{postId}/{imageName}` # 이미지 URL 가져오기

사용자가 요청한 대로, 클린 아키텍처와 `flutter_riverpod` 기반 Flutter 앱(게시물 목록, 작성, 댓글 페이지, 스플래시 화면, TensorFlow Lite와 YOLO로 이미지 검사)의 디렉토리 구조를 마크다운 형식으로 `README.md` 파일에 추가하겠습니다. 이전 대화에서 정의한 Firebase Firestore와 Storage 구조도 함께 포함하며, 현재 날짜와 시간(2025년 5월 16일 오후 3시 53분 KST)을 반영합니다.

---


## 📂 디렉토리 구조

```
flutter_sns_app/
├── assets/
│   └── models/
│       └── yolo.tflite                # YOLO 모델 파일 (TensorFlow Lite 형식)
│       └── labels.txt                 # YOLO 모델 라벨 파일 (예: "person", "car" 등)
├── lib/
│   ├── core/
│   │   └── api_client.dart            # HTTP 클라이언트 (현재는 Firebase로 대체)
│   │   └── firebase_config.dart       # Firebase 초기화 설정 (Firebase.initializeApp 호출)
│   │   └── image_inspector.dart       # TensorFlow Lite와 YOLO로 이미지 검사 (사람 감지 차단)
│   ├── domain/
│   │   ├── entities/
│   │   │   └── post.dart             # 게시물 엔티티: postId, imageUrl, text, tags (List<String>), createdAt
│   │   │   └── comment.dart          # 댓글 엔티티: commentId, text, createdAt
│   │   ├── repositories/
│   │   │   └── post_repository.dart  # 게시물 관련 데이터 액세스 인터페이스 (목록 조회, 작성)
│   │   │   └── comment_repository.dart # 댓글 관련 데이터 액세스 인터페이스 (목록 조회, 작성)
│   │   └── usecases/
│   │       └── get_posts_usecase.dart # 게시물 목록 가져오기 유스케이스 (무한 스크롤 지원)
│   │       └── create_post_usecase.dart # 게시물 작성 유스케이스 (이미지 검사 후 업로드)
│   │       └── get_comments_usecase.dart # 댓글 목록 가져오기 유스케이스
│   │       └── create_comment_usecase.dart # 댓글 작성 유스케이스
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── post_remote_datasource.dart # Firestore에서 게시물 데이터 가져오기/작성
│   │   │   └── comment_remote_datasource.dart # Firestore에서 댓글 데이터 가져오기/작성
│   │   │   └── storage_datasource.dart # Firebase Storage에서 이미지 업로드/URL 가져오기 (검사 후 업로드)
│   │   ├── dtos/
│   │   │   └── post_dto.dart          # 게시물 Firestore 데이터를 엔티티로 변환
│   │   │   └── comment_dto.dart       # 댓글 Firestore 데이터를 엔티티로 변환
│   │   └── repositories/
│   │       └── post_repository_impl.dart # 게시물 리포지토리 구현체 (Firestore 호출, 이미지 검사 포함)
│   │       └── comment_repository_impl.dart # 댓글 리포지토리 구현체 (Firestore 호출)
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── splash_page.dart       # 앱 시작 시 스플래시 화면 (로딩 후 PostListPage로 이동)
│   │   │   └── post_list_page.dart    # 게시물 목록, 무한 스크롤, 새로고침
│   │   │   └── post_create_page.dart  # 게시물 작성, 텍스트 입력, 이미지 업로드 (검사 포함)
│   │   │   └── comment_page.dart      # 세 번째 페이지: 댓글 목록, 댓글 작성, 페이지 이동
│   │   ├── providers/
│   │   │   └── splash_provider.dart   # 스플래시 화면 상태 관리: Firebase 초기화, 초기 데이터 로드
│   │   │   └── post_provider.dart     # 게시물 상태 관리: 목록 로드, 새로고침, 작성 (이미지 검사 포함)
│   │   │   └── comment_provider.dart  # 댓글 상태 관리: 목록 로드, 작성
│   │   └── widgets/ 추후 원하는대로 추가 할 것
│   │       └── post_card.dart         # 게시물/댓글 표시 위젯: 회색 박스, 텍스트, 삼각형 아이콘
│   └── main.dart                      # 앱 진입점: 라우팅 (SplashPage → PostListPage), Riverpod 초기화
├── pubspec.yaml                       # 의존성: flutter_riverpod, firebase_core, cloud_firestore, firebase_storage, tflite_flutter 등
```

---

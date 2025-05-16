
---

# 📚 Firebase 데이터베이스 및 스토리지 구조

## 🌟 개요
이 문서는 Firebase Firestore와 Firebase Storage를 사용한 데이터베이스 구조를 정의합니다. 앱은 게시물 목록 조회(무한 스크롤), 게시물 작성, 댓글 보기/작성을 지원하며, 로그인/회원가입 기능은 제외됩니다. 모든 시간은 2025년 5월 16일 오후 3시 29분(KST)을 기준으로 설정됩니다.

---

## 🔥 Firestore 데이터베이스 구조

### 📋 1. Posts 컬렉션
#### **Firestore 경로**
- `/posts/{postId}`
    - `GET /posts/{postId}` # 특정 게시물 조회
    - `GET /posts` # 게시물 목록 조회 (페이지네이션은 클라이언트에서 구현)
    - `POST /posts` # 새로운 게시물 작성 (Firestore의 `add()` 메서드 사용)

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
#### **Firestore 경로**
- `/posts/{postId}/comments/{commentId}`
    - `GET /posts/{postId}/comments` # 특정 게시물의 댓글 목록 조회
    - `POST /posts/{postId}/comments` # 새로운 댓글 작성 (Firestore의 `add()` 메서드 사용)

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


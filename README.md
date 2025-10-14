# 📚 독서 습관 기록

> Flutter 기반 개인 독서 기록 관리 애플리케이션  

---

## 👨‍💻 개발자
- 이름: 공승환
- 역할: 기획 · 설계 · 개발 전담  
- 이메일: rhd3437@naver.com

---

## ✨ 프로젝트 소개
**독서 습관 트래커**는 사용자가 책을 읽은 기록을 간편하게 저장하고,  
주간/월간 차트와 캘린더를 통해 독서 습관을 시각적으로 확인할 수 있는 모바일 앱입니다.  

Firebase Authentication을 통한 로그인 기능과 Firestore 기반 데이터 저장으로  
안전하고 실시간 동기화되는 독서 관리 서비스를 제공합니다.  

---

## 🛠️ 기술 스택
- **Framework** : Flutter (Dart)
- **Backend / DB** : Firebase Firestore
- **Auth** : Firebase Authentication (Google 로그인)
- **UI/UX** : Material 3, fl_chart, table_calendar, intl
- **State** : 기본 StatefulWidget + StreamBuilder

---

## 📱 주요 기능
- 🔑 **Google 로그인 / 로그아웃** 지원
- ✍️ **독서 기록 저장**
  - 책 제목, 읽은 페이지 수, 날짜, 감상평 저장
- 📊 **차트 시각화**
  - 주간/월간 페이지 수 막대 그래프
- 📅 **캘린더 뷰**
  - 날짜별 독서 기록 확인 및 수정/삭제
- 💬 **감상평 기록**
  - 독서 감상 추가 및 기록 리스트에서 바로 확인 가능
- 🔔 **실시간 동기화**
  - Firebase Firestore 연동으로 즉시 데이터 반영

---

## 📸 실행 화면
<div align="center">
<table>
  <tr>
    <th>로그인</th>
    <th>기록입력</th>
    <th>기록차트구성</th>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/4dd95fc4-e6e1-4f38-b382-0c3d338261b4" width="180" /></td>
    <td><img src="https://github.com/user-attachments/assets/647698bd-01be-42a3-8770-8315396ca87e" width="180" />></td>
    <td><img src="https://github.com/user-attachments/assets/9d7ea350-0de6-47d7-996d-eb7c11844b05" width="180" /><img src="https://github.com/user-attachments/assets/890c799c-0333-4cfd-8dd1-64b7db51bea4" width="180" /></td>
  </tr>
</table>
<table>
  <tr>
    <th>캘린더 기록</th>
    <th>기록 수정</th>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/2b6dd482-ecd9-4999-adb0-570e5ce46186" width="180" /></td>
    <td><img src="https://github.com/user-attachments/assets/3441edba-f3eb-4b86-a9c7-8fbfc77f25ec" width="180" /></td>
  
  </tr>
</table>
</div>

---

## 📌 앞으로 추가할 기능 (계획)
- 🏷️ 책 장르 태그별 통계
- 🏅 독서 달성 배지 시스템

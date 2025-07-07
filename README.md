# TaxRefundCalculator
![92a50ef1a16e710f](https://github.com/user-attachments/assets/fe7fb1ff-ce94-43cb-b222-9908c76325f5)

<br>

## 📦 How to Install
<a href="https://apps.apple.com/us/app/tax-refund-calculator/id6747819893">
    <img src="https://github.com/user-attachments/assets/d692e326-7a7b-44e7-8a22-b204a6616048" width="300">
</a>  

### 클릭 시 앱스토어로 이동합니다.

<br>

## 📱 프로젝트 소개


**택스리펀 계산기**는 해외여행 중 발생하는 부가세 환급(Tax Refund)을 실시간 환율로 쉽게 계산해주는 앱입니다.

- 구매금액 입력만으로 환급 예상 금액과 내 화폐 기준 가격을 확인 가능
- 환급액 기록 및 여행별 지출 정리
- 8개 언어 지원 / 119개국 출시

<br>


## 👥 팀원 소개

| Names     | GitHub   | Parts     |
| -------- | -------- | -----------------------------|
| 이재건   | [@Quaker-Lee](https://github.com/Quaker-Lee) | 시작화면, 계산화면, 설정화면, 프로젝트 초기 세팅, 앱배포 |
| 나영진   | [@bryjna07](https://github.com/bryjna07) | 기록화면, 환율화면, 파이어베이스 세팅 |

<br>

## 📅 프로젝트 기간
2025.04.28 ~ 2025.06.27

<br>

## 🛠 기술 스택
<p>  
    <!-- Swift -->  <img src="https://img.shields.io/badge/Swift-F05138?style=flat&logo=Swift&logoColor=white" height="30"/>  
    <!-- UIKit -->  <img src="https://img.shields.io/badge/UIKit-2396F3?style=flat&logo=apple&logoColor=white" height="30"/>  
    <!-- UserDefaults -->  <img src="https://img.shields.io/badge/UserDefaults-808080?style=flat&logo=apple&logoColor=white" height="30"/>  
    <!-- Then -->  <img src="https://img.shields.io/badge/Then-4CAF50?style=flat&logo=swift&logoColor=white" height="30"/>  
    <!-- SnapKit -->  <img src="https://img.shields.io/badge/SnapKit-FF9800?style=flat&logo=swift&logoColor=white" height="30"/>  
    <!-- Firebase -->  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=white" height="30"/>  
    <!-- Firestore -->  <img src="https://img.shields.io/badge/Firestore-039BE5?style=flat&logo=firebase&logoColor=white" height="30"/>  
    <!-- GitHub -->  <img src="https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white" height="30"/>  
    <!-- Figma -->  <img src="https://img.shields.io/badge/Figma-F24E1E?style=flat&logo=figma&logoColor=white" height="30"/>  
    <!-- Notion -->  <img src="https://img.shields.io/badge/Notion-000000?style=flat&logo=notion&logoColor=white" height="30"/>  
    <!-- Slack -->  <img src="https://img.shields.io/badge/Slack-4A154B?style=flat&logo=slack&logoColor=white" height="30"/>  
    <!-- Combine -->  <img src="https://img.shields.io/badge/Combine-005AFF?style=flat&logo=swift&logoColor=white" height="30"/>  
    <!-- RxSwift -->  <img src="https://img.shields.io/badge/RxSwift-DD0A73?style=flat&logo=swift&logoColor=white" height="30"/>  
</p>

### 프레임워크 및 라이브러리
- **UIKit**: 인터페이스 구현
- **SnapKit**: 코드 기반 AutoLayout
- **Then**: 선언형 UI 구성
- **Firebase Firestore**: 데이터베이스
- **Combine**: 비동기 데이터 스트림 및 이벤트 처리
- **RxSwift + RxCocoa**: 비동기 스트림 처리 및 UI 반응형 바인딩
- **UserDefaults**: 로컬 저장소 관리

### 디자인 패턴
- **Protocol-Delegate**: 모달 및 팝업 데이터 전달
- **MVVM**: 화면(View)과 데이터(Model) 분리, ViewModel을 통한 데이터 바인딩
- **Singleton**: 전역에서 단 하나의 인스턴스만 사용

### API
- **FreeCurrencyAPI**: 실시간 환율 API

<br>

## 🛠 개발 환경
- iOS 16.0+
- Swift 5.0+
  
<br>

## 🧠 프로젝트 아키텍처 (MVVM)

<img width="882" alt="스크린샷 2025-07-06 오후 8 27 23" src="https://github.com/user-attachments/assets/93e095be-1673-402b-9cc0-4033ae816739" />

---

### 📦 ViewModel별 의존성 요약

| ViewModel     | 사용하는 모델/서비스                                       |
|---------------|-------------------------------------------------------------|
| `StartVM`     | ExchangeRateAPIService, ExchangeSyncManager, FirebaseExchangeService, RefundCondition, CurrencyDisplayUnit |
| `CalculateVM` | RefundCondition, CurrencyDisplayUnit                         |
| `SavedVM`     | SavedCard, SaveUserDefaults, RefundCondition                 |
| `SavedModalVM`| SaveUserDefaults                                             |
| `ExchangeVM`  | FirebaseExchangeService, CurrencyDisplayUnit                 |
| `SettingVM`   | FirebaseExchangeService, SaveUserDefaults                    |

<br>

## 📡 데이터 흐름

### 📌 앱 실행 시 초기 환율 동기화
앱이 시작될 때, ExchangeSyncManager를 통해 오늘 날짜 기준 환율 데이터를 Firebase에서 조회합니다.

- ✅ 데이터 존재 → 아무 동작 없음
- ❌ 데이터 없음 → 외부 환율 API에서 요청 후 Firebase에 저장

<img width="870" alt="스크린샷 2025-07-06 오후 8 56 43" src="https://github.com/user-attachments/assets/dcfb1d1c-4bea-4b1e-a6ba-f95e72487b9c" />

### 📌 사용자 상호작용 – 기준 통화 및 여행 국가 선택
사용자가 기준 통화 또는 여행 국가를 선택하면, Firebase에서 동기화된 환율을 기반으로 실시간 환율을 표시합니다.

<img width="875" alt="스크린샷 2025-07-06 오후 8 37 09" src="https://github.com/user-attachments/assets/049822e6-e2a0-4835-a43c-2da3ce93aaee" />

## 🗂 프로젝트 폴더 구조
```
TaxRefundCalculator/
├── Application/              # AppDelegate, SceneDelegate
├── Resources/                # Assets, LaunchScreen
├── SupportingFiles/          # Info.plist, GoogleService-Info.plist
├── API/                      # API 통신 계층
├── CalculatePage/            # 계산 화면
├── ExchangePage/             # 환율 화면
├── Extension/                # UIView 관련 확장
├── Modals/                   # 팝업 모달
├── Models/                   # 데이터 모델
├── SavedPage/                # 저장된 계산 기록
├── SettingPage/              # 설정
├── StartPage/                # 앱 시작 화면
├── TabBar/                   # 탭바 컨트롤러
├── Utils/                    # 유틸리티
└── Localizable/              # 다국어 지원
```

<br>

## ⚡️ 주요 기능
### 🌍 글로벌 119개국 지원
- 전 세계 119개국에서 자유롭게 사용 가능
- 각 국가별 통화 및 환급(부가가치세/VAT) 정책 반영
- 다양한 언어와 국가별 환경에 최적화된 사용자 경험 제공

### 💱 실시간 환율 자동 적용
- 매일 최신 환율 데이터를 자동 반영
- Firebase를 통한 신뢰성 높은 환율 정보 제공
- 구매금액, 환급금, 환급 후 실수령 금액을 내가 사용하는 화폐로 즉시 확인

### 🧮 초간단 택스리펀 계산
- 구매금액만 입력하면 예상 환급액과 실제 내 화폐로 환급받을 금액을 즉시 확인
- 각 국가의 VAT(부가세) 정책에 맞춘 환급액 자동 계산
- 복잡한 공식이나 수식 없이 누구나 쉽게 사용 가능

### 🗂️ 여행 지출 및 환급 내역 기록/관리
- 구매한 물품별로 기록을 남겨 여행 전체 지출 및 환급액을 한눈에 파악
- 나라별·여행별로 기록을 분류하여 체계적으로 관리
- 총 지출 금액, 총 환급액 등 여행 경비를 쉽게 확인

### 🌐 다국어 완전 지원 & 직관적 UI/UX
- 한국어, 영어, 일본어, 스페인어, 독일어, 프랑스어, 이탈리아어, 러시아어 등 8개 언어 지원
- 모든 화면과 안내 메시지가 현지 언어로 자연스럽게 제공
- 소형 기기(아이폰 SE 등) 완벽 지원
- 다크모드 및 접근성 기능 제공

### 🔒 개인정보 미수집 & 안전한 사용
- 사용자 개인정보를 절대 수집, 저장, 전송하지 않음
- 모든 기록은 오직 로컬(사용자 기기)에서만 관리
- App Store 개인정보 보호 가이드라인 100% 준수

### ✈️ 여행자 맞춤 기능
- 기준 통화와 여행 국가의 중복 선택 방지
- 실시간 입력값 검증으로 입력 실수 최소화
- 각 국가별 숫자 표기법/통화 단위 로컬라이징
- 쉽고 빠른 국가, 통화, 언어 선택 및 자동 저장


<br>

## 🔨 Trouble Shooting

<br>

## 📝 Git Convention

<details>
<summary><strong>커밋 메시지</strong></summary>

- Feat: 새로운 기능 추가
- Fix: 버그 수정
- Docs: 문서 수정
- Style: 코드 포맷팅
- Refactor: 코드 리팩토링
- Test: 테스트 코드
- Chore: 기타 변경사항
- Cmt: 주석 수정
</details>


<details>
<summary><strong>PR 규칙</strong></summary>
    
- PR 탬플릿 준수
- 머지 전 팀원의 승인 필요
- 기능별 스크린샷 첨부
</details>

<br>

# 📈 업데이트  
### v1.0.0 
- [Update: 🚀 v1.0.0 런칭](https://github.com/TaxRefundCalculator/TaxRefundCalculator/pull/92)

### v1.0.1
- [Update: 🚀 1.0.1 업데이트](https://github.com/TaxRefundCalculator/TaxRefundCalculator/pull/107)

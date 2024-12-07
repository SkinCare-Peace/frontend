## Frontend

파일 설명

### Constants
- bsti_bbi_image.dart : bsti별 BBI 이미지 parsing
- colors.dart : 자주 사용하는 색 상수화
- null_parsing.dart : 로그인/회원가입 시 전달받은 정보의 null을 ""로 parsing
- scalling.dart : 백엔드 응답 데이터를 정규화 (0~100)
- user_data.dart : 사용자의 정보를 다루는 class
- which_bsti.dart : 사용자의 bsti를 판별하여 반환. (모델+설문)
</br>

### loading : 로딩과 관련된 페이지 
 - loading_page0.dart :  처음 로딩 페이지
 - loading_page1.dart :  설문 전 로딩페이지
 - loading_page2.dart :  루틴생성 로딩 페이지
 - loading_face_result : 얼굴 인식 결과 보여주기전 로딩 페이지
</br>

### addProduct : 현재 있는 제품 추가하기 (건너띄기 누르면 loading_page1로 간다)
 - add_byName.dart : 제품명으로 보유 제품을 검색했을때 이 페이지로 넘어감. 제품을 클릭하고 상세를 볼 수 있음 (현재 백 연결 x)
 - add_main.dart : 보유 제품을 추가하는 메인 페이지로, 검색,장바구니를 들어갈 수 있음(여기에 카테고리 팝업도 존재)
 - added_product : 현재 추가된 제품을 보여주는 로직 (현재 백 연결 x)
</br>

### face_detection : 얼굴인식 관련

 - camera_view.dart : 카메라관련 설정들
 - face_detector_pager.dart : 얼굴 인식 페이지 (여기서 모든 처리가 이루어짐 ex: 서버 요청, 얼굴 틀, 등)
 - guidline.dart : 얼굴 인식 전, 제공되는 가이드라인 페이지
 - face_result.dart : 얼굴 인식결과 (더미데이터)
 - bbox.dart : 얼굴의 각 영역을 bbox로 따오는 부분
 - toserver.dart : 얼굴 인식을 백에게 전송하는 로직
</br>

### record
- calendar_post.dart : 루틴 실천 날짜 정보를 요청
- calendar.dart : 루틴 실천 기록 캘린더 표시
- dash : 사용자의 메인 정보
- insight : 사용자의 피부 정보 통계
</br>

### survey
- survey_info.dart : 설문 결과를 담고 있음.
- survey1~4 : 설문 문항
</br>

### login : 로그인 관련
</br>

### question : 설문 관련
 - question1.dart : 써본 화장품
 - question2.dart : 투자시간
 - question3.dart : 투자 비용
</br>

### routines : 루틴 생성, 관리 관련
 - complete.dart : 루틴 완료를 축하하는 화면
 - routine_create.dart : 루틴을 생성하는 화면 (화장품 추천로직 포함)
 - routine_start.dart : 생성된 루틴이 있으면, 이 페이지에서 루틴을 실천할 수 있다
 - routine_sucessfuly_create : "루틴을 저장중이에요" 로딩페이지
</br>

### main.dart : 메인




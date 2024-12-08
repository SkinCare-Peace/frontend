import 'package:frontend/survey/survey_info.dart';

class DecideBSTI {
  static String whichBSTI(SurveyInfo surveyInfo) {
    String DO, RS, PN, WT;
    // 설문과 모델 값을 조정하여 bsti 결정.

// D:건성	O:지성


// R:민감x	S:민감성
    if (surveyInfo.sensitive1 || surveyInfo.sensitive2) {
      RS = "S";
    } else {
      RS = "R";
    }

// P:색소침착o	N:색소침착x


// W:탄력x	T: 탄력o


    return ("$DO$RS$PN$WT");
  }
}

import 'package:frontend/Constants/scalling.dart';
import 'package:frontend/Constants/sensitive_put.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/record/score_data.dart';
import 'package:frontend/survey/survey_info.dart';
import 'package:frontend/face_detection/regression_data.dart';

class DecideBSTI {
  static String whichBSTI(SurveyInfo surveyInfo, UserData userData) {
    String DO, RS, PN, WT;
    // 설문과 모델 값을 조정하여 bsti 결정.
    final categryData =
        regressionDataStore.getCategoryBasedData(); // 특정 카테고리별 점수
    Map<String, double> selectedData =
        regressionDataStore.aggregateData(categryData); // regression 값 하나씩만 선택
    final scalingData = normalizeResponse(selectedData);

    const double surveyWeight = 0.7;
    const double poreWeight = 0.3;
    const int pivotDO = 40;

    // dryness 값 조정.
    scalingData['dryness'] =
        (scalingData["pore"]! * poreWeight + surveyInfo.oil * surveyWeight)
            .toInt();
    // dash Score 저장.
    dashScore.saveData('dryness', scalingData['dryness']!);
    dashScore.saveData('pigmentation', scalingData['pigmentation']!);
    dashScore.saveData('wrinkle', scalingData['wrinkle']!);
    dashScore.saveData('pore', scalingData['pore']!);

// D:건성	O:지성
    if ((scalingData["pore"]! * poreWeight + surveyInfo.oil * surveyWeight) >=
        pivotDO) {
      DO = "O";
    } else {
      DO = "D";
    }

// R:민감x	S:민감성
    if (surveyInfo.sensitive1 || surveyInfo.sensitive2) {
      updateSensitiveSkinStatus(true, userData);
      RS = "S";
    } else {
      updateSensitiveSkinStatus(false, userData);
      RS = "R";
    }

// P:색소침착o	N:색소침착x
    if ((scalingData["pore"]! + surveyInfo.oil) >= 25) {
      PN = "P";
    } else {
      PN = "N";
    }

// W:탄력x	T: 탄력o
    int T = 0;
    if (userData.age < 35) {
      T++;
    }
    if (scalingData['elasticity']! > 50) {
      T++;
    }
    if (scalingData['wrinkle']! < 50) {
      T++;
    }

    if (T >= 2) {
      WT = "T";
    } else {
      WT = "W";
    }
    T = 0;
    return ("$DO$RS$PN$WT");
  }
}

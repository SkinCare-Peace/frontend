final dashScore = DashScore();
class DashScore {
  final Map<String, int> _acneData = {};
  // 데이터 저장
  void saveData(String areaName, int score) {
    _acneData[areaName] = score;
    print('####### $areaName dash데이터 저장 성공: $score');
  }

}
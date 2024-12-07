class BBISTI {
  static String bstiBBI(String bsti) {
    if (bsti == "ORPT" || bsti == "ORNT" || bsti == "OSPT" || bsti == "OSNT") {
      return 'assets/bstiBBI/O--T.png';
    } else if (bsti == "DRNT" ||
        bsti == "DRNW" ||
        bsti == "DSNT" ||
        bsti == "DSNW") {
      return 'assets/bstiBBI/D-N-.png';
    } else if (bsti == "DRPT" ||
        bsti == "DRPW" ||
        bsti == "DSPT" ||
        bsti == "DSPW") {
      return 'assets/bstiBBI/D-P-.png';
    } else {
      return 'assets/bstiBBI/O--W.png';
    }
  }


static String bstiDescription(String bsti) {
    if (bsti == "ORPT" || bsti == "ORNT" || bsti == "OSPT" || bsti == "OSNT") {
      return "피부가 달처럼 빛이 나요! 지성 피부로 주로 T존이 번들거릴 수 있어요. 클렌징에 신경을 써볼까요?! 유분이 적은 스킨케어도 좋겠어요!";
    } else if (bsti == "DRNT" ||
        bsti == "DRNW" ||
        bsti == "DSNT" ||
        bsti == "DSNW") {
      return "피부가 깨끗하시네요! 건성 피부로 피부가 쉽게 건조해질 수 있어요. 수분 보충에 힘써봅시다!!";
    } else if (bsti == "DRPT" ||
        bsti == "DRPW" ||
        bsti == "DSPT" ||
        bsti == "DSPW") {
      return "피부가 아기처럼 보송해요! 건성 피부로 피부가 쉽게 건조해질 수 있어요. 피부 장벽을 강화하는 관리를 해볼까요?";
    } else {
      return "피부가 달걀처럼 매끈하시네요! 지성 피부로 주로 넓은 모공과 번들거림이 특징이에요. 피지 조절과 보습에 신경을 써볼까요?";
    }
  }

static String bstiMent(String bsti) {
    if (bsti == "ORPT" || bsti == "ORNT" || bsti == "OSPT" || bsti == "OSNT") {
      return "피부가 반짝 빛나는";
    } else if (bsti == "DRNT" ||
        bsti == "DRNW" ||
        bsti == "DSNT" ||
        bsti == "DSNW") {
      return "도화지 피부";
    } else if (bsti == "DRPT" ||
        bsti == "DRPW" ||
        bsti == "DSPT" ||
        bsti == "DSPW") {
      return "발그레한 피부";
    } else {
      return "달걀같은 피부";
    }
  }
}

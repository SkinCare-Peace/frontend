class BBISTI {
  String bstiBBI(String bsti) {
    if (bsti == "ORPT" || bsti == "ORNT" || bsti == "OSPT" || bsti == "OSNT") {
      return "assets/bstiBBI/O--T.png";
    } else if (bsti == "DRNT" ||
        bsti == "DRNW" ||
        bsti == "DSNT" ||
        bsti == "DSNW") {
      return "assets/bstiBBI/D-N-.png";
    } else if (bsti == "DRPT" ||
        bsti == "DRPW" ||
        bsti == "DSPT" ||
        bsti == "DSPW") {
      return "assets/bstiBBI/D-P-.png";
    } else {
      return "assets/bstiBBI/O--W.png";
    }
  }
}

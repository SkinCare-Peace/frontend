import 'dart:io';
import 'dart:ui';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

double translateX(double x, InputImageRotation rotation,

  final Size size, final Size absoluteIamgeSize) {
switch(rotation){
  case InputImageRotation.rotation90deg:
  return x * 
  size.width/
  (Platform.isIOS ? absoluteIamgeSize.width : absoluteIamgeSize.height);

  
  case InputImageRotation.rotation270deg:
    return size.width -x *size.width /
      (Platform.isIOS? absoluteIamgeSize.width :absoluteIamgeSize.height);
  default:
  return x*size.width/absoluteIamgeSize.width;
}
}

double translateY(
final double y, final InputImageRotation rotation,final Size size,final absoluteIamgeSize)
{
  switch(rotation){
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y*size.height/(Platform.isIOS?absoluteIamgeSize.height:absoluteIamgeSize.width);
    default :
    return y*size.height/absoluteIamgeSize.height;
  }
}

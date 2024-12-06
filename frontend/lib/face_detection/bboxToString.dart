import 'dart:ui';
import 'package:flutter/material.dart';


String boundingBoxToString(Rect boundingBox) {
  return [
    boundingBox.left.toInt(),
    boundingBox.top.toInt(),
    boundingBox.right.toInt(),
    boundingBox.bottom.toInt()
  ].join(',');
}

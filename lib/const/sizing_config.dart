import 'package:flutter/cupertino.dart';

double verticalConverter(BuildContext context, double value) {
  double height = MediaQuery.of(context).size.height;
  double referenceHeight = 812;
  if(height > referenceHeight){
    double heightRatio = height / referenceHeight;
    double newValue = heightRatio * value;
    return newValue;
  }
  else{
    double heightRatio = referenceHeight / height;
    double newValue = heightRatio * value;
    return newValue;
  }
}

double horizontalConverter(BuildContext context, double value) {
  double width = MediaQuery.of(context).size.width;
  double referenceWidth = 375;
  if(width > referenceWidth){
    double widthRatio = width / referenceWidth;
    double newValue = widthRatio * value;
    return newValue;
  }
  else{
    double widthRatio = referenceWidth / width;
    double newValue = widthRatio * value;
    return newValue;
  }
}
import 'package:flutter/material.dart';

double getScaleFactor(context)
{
  final double scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;
  return scaleFactor;
}

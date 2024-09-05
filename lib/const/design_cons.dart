import 'package:flutter/material.dart';

final containerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      spreadRadius: 2,
      blurRadius: 5,
      offset: Offset(0, 3),
    ),
  ],
);

final textStyleProduct = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16.0,
);

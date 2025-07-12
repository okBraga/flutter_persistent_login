import 'package:flutter/material.dart';

InputDecoration customInputDecoration({String? labelText, String? hintText}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

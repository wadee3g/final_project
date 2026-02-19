import 'package:flutter/material.dart';

extension Nav on BuildContext {
  void push(Widget target) {
    Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) {
          return target;
        },
      ),
    );
  }

  void pushAndDelete(Widget target) {
    Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(
        builder: (context) {
          return target;
        },
      ),
      (route) => false,
    );
  }
}

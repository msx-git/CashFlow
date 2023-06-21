import 'package:flutter/material.dart';

import '../../data/constants/text_styles.dart';

class CustomChip extends StatelessWidget {
  const CustomChip(
    this.label, {
    Key? key,
  }) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      elevation: 10,
      backgroundColor: Colors.redAccent,
      label: Text(
        label,
        style: textStyle(15, Colors.white, FontWeight.w700),
      ),
    );
  }
}

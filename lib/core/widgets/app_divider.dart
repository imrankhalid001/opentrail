import 'package:flutter/material.dart';

/// Styled horizontal or vertical divider.
class AppDivider extends StatelessWidget {
  final double? indent;
  final double? endIndent;
  final double thickness;

  const AppDivider({
    super.key,
    this.indent,
    this.endIndent,
    this.thickness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(indent: indent, endIndent: endIndent, thickness: thickness);
  }
}

import 'package:flutter/material.dart';

/// Reusable Search Input Bar.
class AppSearchBar extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const AppSearchBar({
    super.key,
    this.hint = 'Search destinations...',
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      hintText: hint,
      onChanged: onChanged,
      leading: const Icon(Icons.search),
      trailing: controller?.text.isNotEmpty == true
          ? [
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              ),
            ]
          : null,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/app_search_bar.dart';

class MapSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  final bool isLoading;

  const MapSearchBar({
    super.key,
    required this.onSearch,
    required this.onClear,
    this.isLoading = false,
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  Timer? _debounce;

  void _onChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (query.isNotEmpty) {
        widget.onSearch(query);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSearchBar(
            hint: context.l10n.mapSearchHint,
            onChanged: _onChanged,
            onClear: () {
              _debounce?.cancel();
              widget.onClear();
            },
          ),
          if (widget.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.xs),
              child: LinearProgressIndicator(minHeight: 2),
            ),
        ],
      ),
    );
  }
}

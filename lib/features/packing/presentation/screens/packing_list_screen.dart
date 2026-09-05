import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../view_models/packing_view_model.dart';

class PackingListScreen extends ConsumerWidget {
  final String tripId;

  const PackingListScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packingState = ref.watch(packingViewModelProvider(tripId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Packing List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_fix_high_rounded),
            onPressed: () {
              // TODO: Get real weather from weatherRepository
              ref
                  .read(packingViewModelProvider(tripId).notifier)
                  .generateSmartList(20.0, false);
            },
            tooltip: 'Generate Smart List',
          ),
        ],
      ),
      body: packingState.when(
        data: (items) {
          if (items.isEmpty) {
            return AppEmptyState(
              title: 'Empty Bag?',
              subtitle: 'Add items manually or use the smart generator to get started.',
              actionLabel: 'Generate Suggestions',
              onAction: () => ref
                  .read(packingViewModelProvider(tripId).notifier)
                  .generateSmartList(20.0, false),
            );
          }

          // Group by category
          final grouped = <String, List<PackingItem>>{};
          for (final item in items) {
            grouped.putIfAbsent(item.category, () => []).add(item);
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      entry.key,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...entry.value.map(
                    (item) => CheckboxListTile(
                      value: item.isPacked,
                      title: Text(item.itemName),
                      onChanged: (val) {
                        if (val != null) {
                          ref
                              .read(packingViewModelProvider(tripId).notifier)
                              .togglePacked(item.id, val);
                        }
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      secondary: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: () => ref
                            .read(packingViewModelProvider(tripId).notifier)
                            .deleteItem(item.id),
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              );
            }).toList(),
          );
        },
        loading: () => const _LoadingState(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Item name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(packingViewModelProvider(tripId).notifier)
                    .addItem(controller.text, 'Manual');
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      itemBuilder: (ctx, idx) => const Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.sm),
        child: AppSkeleton(height: 50),
      ),
    );
  }
}

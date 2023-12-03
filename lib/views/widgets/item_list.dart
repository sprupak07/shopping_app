import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/controllers/item_controller.dart';
import 'package:shopping_app/views/widgets/add_item_dialog.dart';

class ItemList extends ConsumerWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemListControllerProvider);
    return items.when(
      data: (items) => items.isEmpty
          ? const Center(
              child: Text(
                'Tap + to add an item',
                style: TextStyle(fontSize: 20.0),
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  key: ValueKey(item.id),
                  title: Text(item.name),
                  trailing: Checkbox(
                    value: item.obtained,
                    onChanged: (value) => ref
                        .read(itemListControllerProvider.notifier)
                        .updateItem(
                            item: item.copyWith(obtained: !item.obtained)),
                  ),
                  onTap: () => AddItemDialog.show(context, item),
                  onLongPress: () => ref
                      .read(itemListControllerProvider.notifier)
                      .deleteItem(item: item),
                );
              }),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text(e.toString())),
    );
  }
}

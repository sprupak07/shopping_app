import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/controllers/item_controller.dart';
import 'package:shopping_app/models/item_model.dart';

class AddItemDialog extends ConsumerWidget {
  const AddItemDialog({super.key, required this.item});
  final Item item;

  bool get isUpdating => item.id != null;

  static void show(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        item: item,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();
    final itemController = ref.read(itemListControllerProvider.notifier);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: textController,
              autocorrect: true,
              decoration: const InputDecoration(hintText: 'Item Name'),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  isUpdating
                      ? itemController.updateItem(
                          item: item.copyWith(name: textController.text),
                        )
                      : itemController.addItem(
                          item: Item(name: textController.text),
                        );
                  Navigator.of(context).pop();
                },
                child: Text(isUpdating ? 'Update' : 'Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

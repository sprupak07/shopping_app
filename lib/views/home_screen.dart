import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/controllers/auth_controllers.dart';
import 'package:shopping_app/models/item_model.dart';
import 'package:shopping_app/views/widgets/add_item_dialog.dart';
import 'package:shopping_app/views/widgets/item_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider.notifier);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shopping App'),
          // ignore: unnecessary_null_comparison
          leading: auth != null
              ? IconButton(
                  onPressed: () => auth.signOut(),
                  icon: const Icon(Icons.logout),
                )
              : IconButton(
                  onPressed: () => auth, icon: const Icon(Icons.person)),
        ),
        body: ItemList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => AddItemDialog.show(context, Item.empty()),
          child: const Icon(Icons.add),
        ));
  }
}

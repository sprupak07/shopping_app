import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/controllers/auth_controllers.dart';
import 'package:shopping_app/exceptions/custom_exceptions.dart';

import '../models/item_model.dart';
import '../repositories/item_repository.dart';

final itemExceptionProvider = StateProvider<CustomException?>((ref) => null);

final itemListControllerProvider =
    StateNotifierProvider<ItemController, AsyncValue<List<Item>>>((ref) {
  final user = ref.watch(authControllerProvider);
  return ItemController(ref, user!.uid);
});

class ItemController extends StateNotifier<AsyncValue<List<Item>>> {
  final Ref _ref;
  final String _userId;

  ItemController(this._ref, this._userId) : super(const AsyncValue.loading()) {
    if (_userId.isNotEmpty) {
      retriveItems();
    }
  }

  Future<void> retriveItems({bool isRefreshing = false}) async {
    if (isRefreshing) state = const AsyncValue.loading();
    try {
      final items = await _ref
          .read(itemRepositoryProvider)
          .retrieveItems(userId: _userId);
      if (mounted) {
        state = AsyncValue.data(items);
      }
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addItem({required Item item}) async {
    try {
      final itemId = await _ref
          .read(itemRepositoryProvider)
          .addItem(item: item, userId: _userId);

      state.whenData((items) {
        state = AsyncValue.data(items..add(item.copyWith(id: itemId)));
      });
    } on CustomException catch (e) {
      _ref.read(itemExceptionProvider.notifier).state = e;
    }
  }

  Future<void> updateItem({required Item item}) async {
    try {
      await _ref
          .read(itemRepositoryProvider)
          .updateItem(item: item, userId: _userId);

      state.whenData((items) {
        state = AsyncValue.data(
            items.map((e) => e.id == item.id ? item : e).toList());
      });
    } on CustomException catch (e) {
      _ref.read(itemExceptionProvider.notifier).state = e;
    }
  }

  Future<void> deleteItem({required Item item}) async {
    try {
      await _ref
          .read(itemRepositoryProvider)
          .deleteItem(item: item, userId: _userId);

      state.whenData((items) {
        state = AsyncValue.data(items..remove(item));
      });
    } on CustomException catch (e) {
      _ref.read(itemExceptionProvider.notifier).state = e;
    }
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/exceptions/custom_exceptions.dart';
import 'package:shopping_app/general_providers.dart';
import 'package:shopping_app/models/item_model.dart';

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepository(ref);
});

abstract class BaseItemRepository {
  Future<List<Item>> retrieveItems({required userId});
  Future<String> addItem({required Item item, required userId});
  Future<void> updateItem({required Item item, required userId});
  Future<void> deleteItem({required Item item, required userId});
}

class ItemRepository implements BaseItemRepository {
  final Ref _ref;

  const ItemRepository(this._ref);

  @override
  Future<String> addItem({required Item item, required userId}) async {
    try {
      final docRef = await _ref
          .read(firebaseFirestoreProvider)
          .collection('lists')
          .doc(userId)
          .collection('userList')
          .add(item.toDocument());
      ;
      return docRef.id;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> deleteItem({required Item item, required userId}) async {
    try {
      return _ref
          .read(firebaseFirestoreProvider)
          .collection('lists')
          .doc(userId)
          .collection('userList')
          .doc(item.id)
          .delete();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<List<Item>> retrieveItems({required userId}) async {
    try {
      final snap = await _ref
          .read(firebaseFirestoreProvider)
          .collection('lists')
          .doc(userId)
          .collection('userList')
          .get();
      return snap.docs.map((doc) => Item.fromDocument(doc)).toList();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> updateItem({required Item item, required userId}) async {
    try {
      await _ref
          .read(firebaseFirestoreProvider)
          .collection('lists')
          .doc(userId)
          .collection('userList')
          .doc(item.id)
          .update(item.toDocument());
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}

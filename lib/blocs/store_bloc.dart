import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:my_recipes/blocs/bloc_provider.dart';
import 'package:my_recipes/models/recipe.dart';
import 'package:my_recipes/models/unit.dart';

class StoreBloc extends BlocBase {
  final _logger = Logger();

  /// Collection pour la table `recipes` avec la conversion via le model `Recipe`
  final CollectionReference<Recipe> _recipesCollectionReference =
      FirebaseFirestore.instance
          .collection(Recipe.collectionName)
          .withConverter<Recipe>(
            fromFirestore: (snapshot, _) =>
                Recipe.fromFirestore(snapshot.data()!),
            toFirestore: (value, _) => value.toFirestore(),
          );

  Stream<List<Recipe>> get onRecipesChange => _recipesCollectionReference
      .orderBy(Recipe.entryTitle)
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());

  Stream<Recipe?> onRecipeChange(String uid) => _recipesCollectionReference
      .where(Recipe.entryUid, isEqualTo: uid)
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).firstOrNull);

  Future<void> setRecipe(Recipe recipe) async {
    try {
      await _recipesCollectionReference
          .doc(recipe.uid)
          .set(recipe, SetOptions(merge: true));
    } on FirebaseException catch (e, s) {
      _logger.e(
        'setRecipe ERROR',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<Recipe?> getRecipe(String? uid) {
    if (uid == null) return Future.value();
    return _recipesCollectionReference
        .doc(uid)
        .get()
        .then((value) => value.data());
  }

  /// Collection pour la table `units` avec la conversion via le model `Unit`
  final CollectionReference<Unit> _unitsCollectionReference = FirebaseFirestore
      .instance
      .collection(Unit.collectionName)
      .withConverter<Unit>(
        fromFirestore: (snapshot, _) => Unit.fromFirestore(snapshot.data()!),
        toFirestore: (value, _) => value.toFirestore(),
      );

  Future<List<Unit>> get units => _unitsCollectionReference
      .orderBy(Unit.entryLabel)
      .get()
      .then((value) => value.docs.map((e) => e.data()).toList());

  @override
  void dispose() {}

  @override
  void initState() {}
}

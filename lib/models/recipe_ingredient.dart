import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:my_recipes/models/unit.dart';
import 'package:uuid/uuid.dart';

class RecipeIngredient extends Equatable {
  const RecipeIngredient({
    required this.uid,
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory RecipeIngredient.fromFirestore(Map<String, dynamic> json) {
    try {
      return RecipeIngredient(
        uid: json[entryUid] as String,
        name: json[entryName] as String,
        quantity: json[entryQuantity] as num?,
        unit: json[entryUnit] != null
            ? Unit.fromFirestore(json[entryUnit] as Map<String, dynamic>)
            : null,
      );
    } catch (e, s) {
      Logger().e(
        'Error while parsing RecipeIngredient from Firestore',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  factory RecipeIngredient.empty() => RecipeIngredient(
        uid: const Uuid().v4(),
        name: '',
        quantity: null,
        unit: null,
      );

  static const entryUid = 'uid';
  static const entryName = 'name';
  static const entryQuantity = 'quantity';
  static const entryUnit = 'unit';

  final String uid;
  final String name;
  final num? quantity;
  final Unit? unit;

  Map<String, dynamic> toFirestore() {
    try {
      return {
        entryUid: uid,
        entryName: name,
        entryQuantity: quantity,
        entryUnit: unit?.toFirestore(),
      };
    } catch (e, s) {
      Logger().e(
        'Error while converting RecipeIngredient to Firestore',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  RecipeIngredient copyWith({
    String? uid,
    String? name,
    num? quantity,
    Unit? unit,
  }) {
    return RecipeIngredient(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  @override
  List<Object?> get props => [uid, name, quantity, unit];
}

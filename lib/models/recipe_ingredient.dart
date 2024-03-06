import 'package:equatable/equatable.dart';
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
    return RecipeIngredient(
      uid: json[entryUid] as String,
      name: json[entryName] as String,
      quantity: json[entryQuantity] as double?,
      unit: json[entryUnit] != null
          ? Unit.fromFirestore(json[entryUnit] as Map<String, dynamic>)
          : null,
    );
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
  final double? quantity;
  final Unit? unit;

  Map<String, dynamic> toFirestore() => {
        entryUid: uid,
        entryName: name,
        entryQuantity: quantity,
        entryUnit: unit?.toFirestore(),
      };

  RecipeIngredient copyWith({
    String? uid,
    String? name,
    double? quantity,
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

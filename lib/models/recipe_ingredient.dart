import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class RecipeIngredient extends Equatable {
  const RecipeIngredient({
    required this.uid,
    required this.name,
  });

  factory RecipeIngredient.fromFirestore(Map<String, dynamic> json) {
    return RecipeIngredient(
      uid: json[entryUid] as String,
      name: json[entryName] as String,
    );
  }

  factory RecipeIngredient.empty() =>
      RecipeIngredient(uid: const Uuid().v4(), name: '');

  static const entryUid = 'uid';
  static const entryName = 'name';

  final String uid;
  final String name;

  Map<String, dynamic> toFirestore() => {
        entryUid: uid,
        entryName: name,
      };

  RecipeIngredient copyWith({
    String? uid,
    String? name,
  }) {
    return RecipeIngredient(
      uid: uid ?? this.uid,
      name: name ?? this.name,
    );
  }

  @override
  List<Object> get props => [uid, name];
}

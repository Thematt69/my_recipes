import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class RecipeStep extends Equatable {
  const RecipeStep({
    required this.uid,
    required this.description,
  });

  factory RecipeStep.fromFirestore(Map<String, dynamic> json) {
    return RecipeStep(
      uid: json[entryUid] as String,
      description: json[entryDescription] as String,
    );
  }

  factory RecipeStep.empty() =>
      RecipeStep(uid: const Uuid().v4(), description: '');

  static const entryUid = 'uid';
  static const entryDescription = 'description';

  final String uid;
  final String description;

  Map<String, dynamic> toFirestore() => {
        entryUid: uid,
        entryDescription: description,
      };

  RecipeStep copyWith({
    String? uid,
    String? description,
  }) {
    return RecipeStep(
      uid: uid ?? this.uid,
      description: description ?? this.description,
    );
  }

  @override
  List<Object> get props => [uid, description];
}

import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class RecipeStep extends Equatable {
  const RecipeStep({
    required this.uid,
    required this.description,
  });

  factory RecipeStep.fromFirestore(Map<String, dynamic> json) {
    try {
      return RecipeStep(
        uid: json[entryUid] as String,
        description: json[entryDescription] as String,
      );
    } catch (e, s) {
      Logger().e(
        'Error while parsing RecipeStep from Firestore',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  factory RecipeStep.empty() =>
      RecipeStep(uid: const Uuid().v4(), description: '');

  static const entryUid = 'uid';
  static const entryDescription = 'description';

  final String uid;
  final String description;

  Map<String, dynamic> toFirestore() {
    try {
      return {
        entryUid: uid,
        entryDescription: description,
      };
    } catch (e, s) {
      Logger().e(
        'Error while converting RecipeStep to Firestore',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

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

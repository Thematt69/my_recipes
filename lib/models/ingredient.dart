import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  const Ingredient({
    required this.uid,
    required this.label,
  });

  static const collectionName = 'ingredients';
  static const entryUid = 'uid';
  static const entryLabel = 'label';

  final String uid;
  final String label;

  // TODO(Matthieu): Define ingrediant details

  Ingredient copyWith({
    String? uid,
    String? label,
  }) {
    return Ingredient(
      uid: uid ?? this.uid,
      label: label ?? this.label,
    );
  }

  @override
  List<Object> get props => [
        uid,
        label,
      ];
}

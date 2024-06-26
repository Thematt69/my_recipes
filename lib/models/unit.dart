import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// Litre(s) - e9XU3p3q6xqzi6CLA0ir
///
/// 0.001 litre = 1 millilitres - tQM9w17aAFr7AYMuvn9P
/// 0.01 litre = 1 centilitres - eC7VaEOAuyRuPz45i2l1
///
/// Gramme(s) - I3DzYRGj8AVwjVrsnHxZ
///
/// 0.001 gramme = 1 milligrammes - KEPS45McXj8NNdIqTV62
/// 0.01 gramme = 1 centigrammes - yCCH2o3xw2QwUMuiDO52
/// 1000 grammes = 1 kilogramme - Bwg8Hw8pXelKYnODQZBz
///
/// Cuillière(s) à soupe rase(s) - 3sWDbdrUca3VxE3zhhUe
///
/// Cuillière(s) à café rase(s) - vSvrUFjhVGa8AFzOvUXw
///
/// Pincée(s) - 9lQObkg1setoGQtk0ac4
///
/// Verre(s) rase(s) - dXjCGbN5q6oGOBlhAZFi
///
/// Pots(s) rase(s) - xycExKlqS7m3PTQKN2b1

class Unit extends Equatable {
  const Unit({
    required this.uid,
    required this.label,
    this.masterUnit,
    this.masterFactor,
  }) : assert(
          masterUnit == null && masterFactor == null ||
              masterUnit != null && masterFactor != null,
          'Both masterUnit and masterFactor must be set or both must be null.',
        );

  factory Unit.fromFirestore(Map<String, dynamic> json) {
    try {
      return Unit(
        uid: json[entryUid] as String,
        label: json[entryLabel] as String,
        masterUnit: json[entryMasterUnit] == null
            ? null
            : Unit.fromFirestore(json[entryMasterUnit] as Map<String, dynamic>),
        masterFactor: json[entryMasterFactor] as num?,
      );
    } catch (e, s) {
      Logger().e(
        'Error while parsing Unit from Firestore',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  factory Unit.empty() => Unit(uid: const Uuid().v4(), label: '');

  static const collectionName = 'units';
  static const entryUid = 'uid';
  static const entryLabel = 'label';
  static const entryMasterUnit = 'masterUnit';
  static const entryMasterFactor = 'masterFactor';

  final String uid;
  final String label;
  final Unit? masterUnit;
  final num? masterFactor;

  Map<String, dynamic> toFirestore() {
    try {
      return {
        entryUid: uid,
        entryLabel: label,
        entryMasterUnit: masterUnit?.toFirestore(),
        entryMasterFactor: masterFactor,
      };
    } catch (e, s) {
      Logger().e(
        'Error while converting Unit to Firestore',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Unit copyWith({
    String? uid,
    String? label,
    Unit? masterUnit,
    num? masterFactor,
  }) {
    return Unit(
      uid: uid ?? this.uid,
      label: label ?? this.label,
      masterUnit: masterUnit ?? this.masterUnit,
      masterFactor: masterFactor ?? this.masterFactor,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        label,
        masterUnit,
        masterFactor,
      ];
}

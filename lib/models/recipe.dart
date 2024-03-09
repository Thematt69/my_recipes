import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:my_recipes/models/recipe_ingredient.dart';
import 'package:my_recipes/models/recipe_step.dart';

class Recipe extends Equatable {
  const Recipe({
    required this.uid,
    required this.title,
    required this.portionCount,
    required this.setupTime,
    required this.cookingTime,
    required this.standingTime,
    required this.ingredients,
    required this.steps,
    required this.source,
  });

  factory Recipe.fromFirestore(Map<String, dynamic> json) {
    try {
      return Recipe(
        uid: json[entryUid] as String,
        title: json[entryTitle] as String,
        portionCount: json[entryPortionCount] as int,
        setupTime: json[entrySetupTime] as int?,
        cookingTime: json[entryCookingTime] as int?,
        standingTime: json[entryStandingTime] as int?,
        ingredients: (json[entryIngredients] as List)
            .map(
              (e) => RecipeIngredient.fromFirestore(e as Map<String, dynamic>),
            )
            .toList(),
        steps: (json[entrySteps] as List)
            .map((e) => RecipeStep.fromFirestore(e as Map<String, dynamic>))
            .toList(),
        source: json[entrySource] as String,
      );
    } catch (e, s) {
      Logger().e(
        'Error while parsing Recipe from Firestore',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  static const collectionName = 'recipes';
  static const entryUid = 'uid';
  static const entryTitle = 'title';
  static const entryPortionCount = 'portionCount';
  static const entrySetupTime = 'setupTime';
  static const entryCookingTime = 'cookingTime';
  static const entryStandingTime = 'standingTime';
  static const entryIngredients = 'ingredients';
  static const entrySteps = 'steps';
  static const entrySource = 'source';

  final String uid;
  final String title;
  final int portionCount;
  final int? setupTime;
  final int? cookingTime;
  final int? standingTime;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final String source;

  int get totalTime =>
      (setupTime ?? 0) + (cookingTime ?? 0) + (standingTime ?? 0);

  Uri? get sourceUri {
    if (RegExp(
      r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?",
      caseSensitive: false,
    ).hasMatch(source)) {
      return Uri.tryParse(source);
    }
    return null;
  }

  Map<String, dynamic> toFirestore() {
    try {
      return {
        entryUid: uid,
        entryTitle: title,
        entryPortionCount: portionCount,
        entrySetupTime: setupTime,
        entryCookingTime: cookingTime,
        entryStandingTime: standingTime,
        entryIngredients: ingredients.map((e) => e.toFirestore()).toList(),
        entrySteps: steps.map((e) => e.toFirestore()).toList(),
        entrySource: source,
      };
    } catch (e, s) {
      Logger().e(
        'Error while converting Recipe to Firestore',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Recipe copyWith({
    String? uid,
    String? title,
    int? portionCount,
    int? setupTime,
    int? cookingTime,
    int? standingTime,
    List<RecipeIngredient>? ingredients,
    List<RecipeStep>? steps,
    String? source,
  }) {
    return Recipe(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      portionCount: portionCount ?? this.portionCount,
      setupTime: setupTime ?? this.setupTime,
      cookingTime: cookingTime ?? this.cookingTime,
      standingTime: standingTime ?? this.standingTime,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      source: source ?? this.source,
    );
  }

  @override
  List<Object?> get props {
    return [
      uid,
      title,
      portionCount,
      setupTime,
      cookingTime,
      standingTime,
      ingredients,
      steps,
      source,
    ];
  }
}

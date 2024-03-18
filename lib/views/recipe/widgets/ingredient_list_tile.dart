import 'package:flutter/material.dart';
import 'package:my_recipes/extensions/num_extension.dart';
import 'package:my_recipes/models/recipe_ingredient.dart';

class IngredientListTile extends StatelessWidget {
  const IngredientListTile(
    this.ingredient, {
    super.key,
  });

  final RecipeIngredient ingredient;

  @override
  Widget build(BuildContext context) {
    late String label;

    if (ingredient.quantity != null && ingredient.unit != null) {
      label =
          "${ingredient.name} (${ingredient.quantity!.toQuantityString()} ${ingredient.unit!.label})";
    } else if (ingredient.quantity != null) {
      label = "${ingredient.name} (${ingredient.quantity!.toQuantityString()})";
    } else {
      label = ingredient.name;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        "- $label",
      ),
    );
  }
}

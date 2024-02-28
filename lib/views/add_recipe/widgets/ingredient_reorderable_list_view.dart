import 'package:flutter/material.dart';
import 'package:my_recipes/models/recipe_ingredient.dart';

class IngredientReorderableListView extends StatelessWidget {
  const IngredientReorderableListView({
    super.key,
    required this.ingredientsController,
  });

  final ValueNotifier<List<RecipeIngredient>> ingredientsController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<RecipeIngredient>>(
      valueListenable: ingredientsController,
      builder: (context, ingredients, _) {
        return ReorderableListView.builder(
          buildDefaultDragHandles: false,
          shrinkWrap: true,
          itemCount: ingredients.length,
          onReorder: (oldIndex, newIndex) {
            final newIngredients = List<RecipeIngredient>.from(ingredients);
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final ingredient = newIngredients.removeAt(oldIndex);
            newIngredients.insert(newIndex, ingredient);
            ingredientsController.value = newIngredients;
          },
          itemBuilder: (context, index) {
            final ingredient = ingredients[index];

            return Padding(
              key: ValueKey(ingredient.uid),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  ReorderableDragStartListener(
                    key: ValueKey(ingredient.uid),
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: ingredient.name,
                      onChanged: (value) {
                        final newIngredients = List<RecipeIngredient>.from(
                          ingredients,
                        );
                        newIngredients[index] = RecipeIngredient(
                          uid: ingredient.uid,
                          name: value,
                        );
                        ingredientsController.value = newIngredients;
                      },
                      decoration: InputDecoration(
                        labelText: 'Ingrédient ${index + 1}*',
                        border: const OutlineInputBorder(),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "L'ingrédient ne peut pas être vide";
                        }
                        return null;
                      },
                    ),
                  ),
                  if (index != 0 && index == ingredients.length - 1) ...[
                    const SizedBox(width: 12),
                    IconButton.outlined(
                      onPressed: () {
                        final newIngredients =
                            List<RecipeIngredient>.from(ingredients)
                              ..removeAt(index);
                        ingredientsController.value = newIngredients;
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                  if (ingredient.name.isNotEmpty &&
                      index == ingredients.length - 1) ...[
                    const SizedBox(width: 12),
                    IconButton.outlined(
                      onPressed: () {
                        final newIngredients =
                            List<RecipeIngredient>.from(ingredients)
                              ..add(RecipeIngredient.empty());
                        ingredientsController.value = newIngredients;
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

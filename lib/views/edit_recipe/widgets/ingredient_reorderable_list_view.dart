import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/models/recipe_ingredient.dart';
import 'package:my_recipes/models/unit.dart';

class IngredientReorderableListView extends StatelessWidget {
  const IngredientReorderableListView({
    super.key,
    required this.ingredientsController,
    required this.scrollController,
    required this.isReordering,
    required this.units,
  });

  final ValueNotifier<List<RecipeIngredient>> ingredientsController;
  final ScrollController scrollController;
  final bool isReordering;
  final List<Unit> units;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<RecipeIngredient>>(
      valueListenable: ingredientsController,
      builder: (context, ingredients, _) {
        return ReorderableListView.builder(
          scrollController: scrollController,
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
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  if (isReordering) ...[
                    ReorderableDragStartListener(
                      key: ValueKey(ingredient.uid),
                      index: index,
                      child: const Icon(Icons.drag_handle),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: ingredient.name,
                          onChanged: (value) {
                            final newIngredients = List<RecipeIngredient>.from(
                              ingredients,
                            );
                            newIngredients[index] = RecipeIngredient(
                              uid: ingredient.uid,
                              name: value,
                              quantity: ingredient.quantity,
                              unit: ingredient.unit,
                            );
                            ingredientsController.value = newIngredients;
                          },
                          decoration: InputDecoration(
                            labelText: 'Ingrédient ${index + 1}*',
                            border: const OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return "L'ingrédient ne peut pas être vide";
                            }
                            return null;
                          },
                          autofocus: index != 0 && ingredient.name.isEmpty,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    ingredient.quantity?.toString() ?? '',
                                onChanged: (value) {
                                  final newIngredients =
                                      List<RecipeIngredient>.from(
                                    ingredients,
                                  );
                                  newIngredients[index] = RecipeIngredient(
                                    uid: ingredient.uid,
                                    name: ingredient.name,
                                    quantity: double.tryParse(value),
                                    unit: ingredient.unit,
                                  );
                                  ingredientsController.value = newIngredients;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Quantité',
                                  border: OutlineInputBorder(),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9.]'),
                                  ),
                                ],
                                keyboardType: TextInputType.number,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      double.tryParse(value) == null) {
                                    return "La quantité doit être un nombre valide";
                                  }
                                  return null;
                                },
                                autofocus:
                                    index != 0 && ingredient.name.isEmpty,
                              ),
                            ),
                            const SizedBox(width: 12),
                            DropdownMenu(
                              initialSelection: ingredient.unit,
                              label: const Text('Unité'),
                              enableFilter: true,
                              searchCallback: (entries, query) {
                                if (query.isEmpty) return null;
                                final index = entries.indexWhere(
                                  (entry) => entry.label == query,
                                );

                                return index != -1 ? index : null;
                              },
                              dropdownMenuEntries: [
                                for (final unit in units)
                                  DropdownMenuEntry(
                                    value: unit,
                                    label: unit.label,
                                  ),
                              ],
                              onSelected: (value) {
                                final newIngredients =
                                    List<RecipeIngredient>.from(
                                  ingredients,
                                );
                                newIngredients[index] = RecipeIngredient(
                                  uid: ingredient.uid,
                                  name: ingredient.name,
                                  quantity: ingredient.quantity,
                                  unit: value,
                                );
                                ingredientsController.value = newIngredients;
                              },
                            ),
                            if (index != 0 &&
                                index == ingredients.length - 1) ...[
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

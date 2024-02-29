import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/blocs/bloc_provider.dart';
import 'package:my_recipes/blocs/store_bloc.dart';
import 'package:my_recipes/models/recipe.dart';
import 'package:my_recipes/models/recipe_ingredient.dart';
import 'package:my_recipes/models/recipe_step.dart';
import 'package:my_recipes/views/add_recipe/widgets/ingredient_reorderable_list_view.dart';
import 'package:my_recipes/views/add_recipe/widgets/step_reorderable_list_view.dart';
import 'package:uuid/uuid.dart';

class AddRecipeView extends StatefulWidget {
  const AddRecipeView({super.key});

  @override
  State<AddRecipeView> createState() => _AddRecipeViewState();
}

class _AddRecipeViewState extends State<AddRecipeView> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _titleController = TextEditingController();
  final _portionCountController = TextEditingController();
  final _setupTimeController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _standingTimeController = TextEditingController();
  final _ingredientsController =
      ValueNotifier<List<RecipeIngredient>>([RecipeIngredient.empty()]);
  final _ingredientsIsReordering = ValueNotifier<bool>(false);
  final _stepsController =
      ValueNotifier<List<RecipeStep>>([RecipeStep.empty()]);
  final _stepsIsReordering = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _titleController.dispose();
    _portionCountController.dispose();
    _setupTimeController.dispose();
    _cookingTimeController.dispose();
    _standingTimeController.dispose();
    _ingredientsController.dispose();
    _ingredientsIsReordering.dispose();
    _stepsController.dispose();
    _stepsIsReordering.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une recette'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Informations générales',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titre*',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Le titre ne peut pas être vide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _portionCountController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de portions*',
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Le nombre de portions doit être un nombre entier';
                            } else if (int.tryParse(value!) == null) {
                              return 'Le nombre de portions doit être un nombre entier';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _setupTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Temps de préparation (en minutes)',
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                int.tryParse(value) == null) {
                              return 'Le temps de préparation doit être un nombre entier';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cookingTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Temps de cuisson (en minutes)',
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                int.tryParse(value) == null) {
                              return 'Le temps de cuisson doit être un nombre entier';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _standingTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Temps de repos (en minutes)',
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                int.tryParse(value) == null) {
                              return 'Le temps de repos doit être un nombre entier';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder(
                    valueListenable: _ingredientsIsReordering,
                    builder: (context, isReordering, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Ingrédients',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _ingredientsIsReordering.value =
                                      !_ingredientsIsReordering.value;
                                },
                                child: Text(
                                  isReordering ? 'Confirmer' : 'Réordonner',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12 - 8),
                          IngredientReorderableListView(
                            ingredientsController: _ingredientsController,
                            scrollController: _scrollController,
                            isReordering: isReordering,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16 - 8),
                  ValueListenableBuilder(
                    valueListenable: _stepsIsReordering,
                    builder: (context, isReordering, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Étapes',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _stepsIsReordering.value =
                                      !_stepsIsReordering.value;
                                },
                                child: Text(
                                  isReordering ? 'Confirmer' : 'Réordonner',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12 - 8),
                          StepReorderableListView(
                            stepsController: _stepsController,
                            scrollController: _scrollController,
                            isReordering: isReordering,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16 - 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final recipe = Recipe(
                            uid: const Uuid().v4(),
                            title: _titleController.text,
                            portionCount:
                                int.parse(_portionCountController.text),
                            setupTime: int.tryParse(_setupTimeController.text),
                            cookingTime:
                                int.tryParse(_cookingTimeController.text),
                            standingTime:
                                int.tryParse(_standingTimeController.text),
                            ingredients: _ingredientsController.value,
                            steps: _stepsController.value,
                          );

                          BlocProvider.of<StoreBloc>(context).setRecipe(recipe);

                          context.pop();
                        }
                      },
                      child: const Text('Enregistrer la recette'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/blocs/bloc_provider.dart';
import 'package:my_recipes/blocs/store_bloc.dart';
import 'package:my_recipes/models/recipe.dart';
import 'package:my_recipes/models/recipe_ingredient.dart';
import 'package:my_recipes/models/recipe_step.dart';
import 'package:my_recipes/models/unit.dart';
import 'package:my_recipes/views/edit_recipe/widgets/ingredient_reorderable_list_view.dart';
import 'package:my_recipes/views/edit_recipe/widgets/step_reorderable_list_view.dart';
import 'package:uuid/uuid.dart';

class EditRecipeView extends StatefulWidget {
  const EditRecipeView({
    super.key,
    required this.recipeUid,
  });

  final String? recipeUid;

  @override
  State<EditRecipeView> createState() => _EditRecipeViewState();
}

class _EditRecipeViewState extends State<EditRecipeView> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _titleController = TextEditingController();
  final _portionCountController = TextEditingController();
  final _setupTimeController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _standingTimeController = TextEditingController();
  final _sourceController = TextEditingController();
  final _ingredientsIsReordering = ValueNotifier<bool>(false);
  final _ingredientsController =
      ValueNotifier<List<RecipeIngredient>>([RecipeIngredient.empty()]);
  final _stepsIsReordering = ValueNotifier<bool>(false);
  final _stepsController =
      ValueNotifier<List<RecipeStep>>([RecipeStep.empty()]);

  @override
  void dispose() {
    _scrollController.dispose();
    _titleController.dispose();
    _portionCountController.dispose();
    _setupTimeController.dispose();
    _cookingTimeController.dispose();
    _standingTimeController.dispose();
    _sourceController.dispose();
    _ingredientsController.dispose();
    _ingredientsIsReordering.dispose();
    _stepsController.dispose();
    _stepsIsReordering.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Êtes-vous sûr de vouloir quitter ?'),
              content: const Text(
                'Toutes les modifications non enregistrées seront perdues. Êtes-vous sûr de vouloir quitter ?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop(false);
                  },
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    context.pop(true);
                  },
                  child: const Text('Quitter'),
                ),
              ],
            );
          },
        ).then((didPop) {
          if (didPop ?? false) {
            context.pop();
          }
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Éditer une recette'),
        ),
        body: FutureBuilder(
          future: Future.wait([
            BlocProvider.of<StoreBloc>(context).units,
            BlocProvider.of<StoreBloc>(context).getRecipe(widget.recipeUid),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError) {
              if (snapshot.hasError) {
                // TODO(Matthieu): Log error
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final units = (snapshot.data?[0] as List<Unit>?) ?? <Unit>[];
            final originalRecipe = snapshot.data?[1] as Recipe?;

            if (originalRecipe != null) {
              _titleController.text = originalRecipe.title;
              _portionCountController.text =
                  originalRecipe.portionCount.toString();
              _setupTimeController.text =
                  originalRecipe.setupTime?.toString() ?? '';
              _cookingTimeController.text =
                  originalRecipe.cookingTime?.toString() ?? '';
              _standingTimeController.text =
                  originalRecipe.standingTime?.toString() ?? '';
              _sourceController.text = originalRecipe.source;
              _ingredientsController.value = originalRecipe.ingredients;
              _stepsController.value = originalRecipe.steps;
            }

            return SingleChildScrollView(
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                  labelText:
                                      'Temps de préparation (en minutes)',
                                  border: OutlineInputBorder(),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _sourceController,
                          decoration: const InputDecoration(
                            labelText: 'Source*',
                            border: OutlineInputBorder(),
                            hintText: 'Site web, livre, etc.',
                          ),
                          keyboardType: TextInputType.url,
                          textCapitalization: TextCapitalization.sentences,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'La source ne peut pas être vide';
                            } else if ((value!.startsWith('http') ||
                                    value.startsWith('www')) &&
                                !RegExp(
                                  r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?",
                                  caseSensitive: false,
                                ).hasMatch(value)) {
                              return 'La source doit être un lien valide';
                            }
                            return null;
                          },
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _ingredientsIsReordering.value =
                                            !_ingredientsIsReordering.value;
                                      },
                                      child: Text(
                                        isReordering
                                            ? 'Confirmer'
                                            : 'Réordonner',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12 - 8),
                                IngredientReorderableListView(
                                  ingredientsController: _ingredientsController,
                                  scrollController: _scrollController,
                                  isReordering: isReordering,
                                  units: units,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _stepsIsReordering.value =
                                            !_stepsIsReordering.value;
                                      },
                                      child: Text(
                                        isReordering
                                            ? 'Confirmer'
                                            : 'Réordonner',
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
                                  uid: originalRecipe?.uid ?? const Uuid().v4(),
                                  title: _titleController.text,
                                  portionCount:
                                      int.parse(_portionCountController.text),
                                  setupTime:
                                      int.tryParse(_setupTimeController.text),
                                  cookingTime:
                                      int.tryParse(_cookingTimeController.text),
                                  standingTime: int.tryParse(
                                    _standingTimeController.text,
                                  ),
                                  ingredients: _ingredientsController.value,
                                  steps: _stepsController.value,
                                  source: _sourceController.text,
                                );

                                BlocProvider.of<StoreBloc>(context)
                                    .setRecipe(recipe);

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
            );
          },
        ),
      ),
    );
  }
}

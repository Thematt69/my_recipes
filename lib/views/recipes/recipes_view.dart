import 'package:flutter/material.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/blocs/bloc_provider.dart';
import 'package:my_recipes/blocs/store_bloc.dart';
import 'package:my_recipes/extensions/string_extension.dart';
import 'package:my_recipes/models/recipe.dart';
import 'package:my_recipes/views/recipes/widgets/recipe_list_tile.dart';

enum _RecipeFilter {
  lessThan30Min,
  lessThan1H,
  moreThan1H;

  String get label {
    switch (this) {
      case lessThan30Min:
        return 'Inférieur à 30 min';
      case lessThan1H:
        return 'Inférieur à 1 h';
      case moreThan1H:
        return "Plus d'1 h";
    }
  }
}

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  final _searchController = ValueNotifier<String>('');
  final _filterController = ValueNotifier<_RecipeFilter?>(null);

  @override
  void dispose() {
    _searchController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes recettes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80 + 36 + 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: TextFormField(
                    initialValue: _searchController.value,
                    onChanged: (string) => _searchController.value = string,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Rechercher une recette',
                      suffixIcon: IconButton(
                        onPressed: () => _searchController.value = '',
                        icon: const Icon(Icons.backspace_outlined),
                        tooltip: 'Effacer la recherche',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _RecipeFilter.values.length,
                    itemBuilder: (context, index) {
                      final filter = _RecipeFilter.values[index];

                      return ValueListenableBuilder(
                        valueListenable: _filterController,
                        builder: (context, filterValue, _) => FilterChip(
                          selected: filterValue == filter,
                          label: Text(filter.label),
                          onSelected: (value) {
                            _filterController.value = value ? filter : null;
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoute.addRecipe.name),
        label: const Text('Ajouter une recette'),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: BlocProvider.of<StoreBloc>(context).onRecipesChange,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final recipes = snapshot.data;

          if (recipes == null || recipes.isEmpty) {
            return const Center(
              child: Text('Aucune recette'),
            );
          }

          return ValueListenableBuilder(
            valueListenable: _filterController,
            builder: (context, filterValue, _) {
              final List<Recipe> filteredRecipes = recipes.where(
                (recipe) {
                  if (filterValue == null) return true;

                  switch (filterValue) {
                    case _RecipeFilter.lessThan30Min:
                      return recipe.totalTime < 30;
                    case _RecipeFilter.lessThan1H:
                      return recipe.totalTime < 60;
                    case _RecipeFilter.moreThan1H:
                      return recipe.totalTime >= 60;
                  }
                },
              ).toList();

              if (filteredRecipes.isEmpty) {
                return const Center(
                  child: Text('Aucune recette pour ce filtre'),
                );
              }

              return ValueListenableBuilder<String>(
                valueListenable: _searchController,
                builder: (context, searchValue, _) {
                  final List<Recipe> filteredSearchRecipes = filteredRecipes
                      .where(
                        (recipe) =>
                            recipe.title.containsNoDiacritics(searchValue),
                      )
                      .toList();

                  if (filteredSearchRecipes.isEmpty) {
                    return const Center(
                      child: Text('Aucune recette pour cette recherche'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16 + 54 + 16),
                    itemCount: filteredSearchRecipes.length,
                    itemBuilder: (context, index) =>
                        RecipeListTile(filteredSearchRecipes[index]),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

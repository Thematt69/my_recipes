import 'package:flutter/material.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/blocs/bloc_provider.dart';
import 'package:my_recipes/blocs/store_bloc.dart';
import 'package:my_recipes/extensions/string_extension.dart';
import 'package:my_recipes/models/filter_setup.dart';
import 'package:my_recipes/models/recipe.dart';
import 'package:my_recipes/views/recipes/widgets/filter_dialog.dart';
import 'package:my_recipes/views/recipes/widgets/recipe_list_tile.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  final _searchTextController = TextEditingController();
  final _searchController = ValueNotifier<String>('');
  final _filterController = ValueNotifier<FilterSetup>(const FilterSetup());

  @override
  void initState() {
    _searchTextController.addListener(() {
      _searchController.value = _searchTextController.text;
    });
    super.initState();
  }

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
        actions: [
          IconButton(
            onPressed: () async {
              final filterSetup = await showDialog<FilterSetup?>(
                context: context,
                builder: (context) => FilterDialog(
                  filterSetup: _filterController.value,
                ),
              );
              if (filterSetup != null) {
                _filterController.value = filterSetup;
              }
            },
            icon: const Icon(Icons.filter_list_outlined),
            tooltip: 'Filtrer les recettes',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: TextFormField(
                controller: _searchTextController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Rechercher une recette',
                  suffixIcon: IconButton(
                    onPressed: _searchTextController.clear,
                    icon: const Icon(Icons.backspace_outlined),
                    tooltip: 'Effacer la recherche',
                  ),
                ),
              ),
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
                  if (recipe.totalTime < filterValue.minTotalTime) {
                    return false;
                  }
                  if (recipe.totalTime > filterValue.maxTotalTime) {
                    return false;
                  }
                  if (!filterValue.webSource && recipe.sourceUri != null) {
                    return false;
                  }
                  if (!filterValue.bookSource && recipe.sourceUri == null) {
                    return false;
                  }
                  return true;
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

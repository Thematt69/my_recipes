import 'package:flutter/material.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/blocs/bloc_provider.dart';
import 'package:my_recipes/blocs/store_bloc.dart';
import 'package:my_recipes/models/recipe.dart';
import 'package:my_recipes/views/recipes/widgets/recipe_list_tile.dart';

class RecipesView extends StatelessWidget {
  const RecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes recettes'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(AppRoute.addRecipe.name);
        },
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

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) => RecipeListTile(recipes[index]),
          );
        },
      ),
    );
  }
}

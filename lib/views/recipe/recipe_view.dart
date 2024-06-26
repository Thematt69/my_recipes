import 'package:flutter/material.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/blocs/bloc_provider.dart';
import 'package:my_recipes/blocs/store_bloc.dart';
import 'package:my_recipes/extensions/int_extension.dart';
import 'package:my_recipes/models/recipe.dart';
import 'package:my_recipes/views/recipe/widgets/ingredient_list_tile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeView extends StatelessWidget {
  const RecipeView({
    super.key,
    required this.uid,
  });

  final String? uid;

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Aucune recette'),
        ),
      );
    }

    return StreamBuilder<Recipe?>(
      stream: BlocProvider.of<StoreBloc>(context).onRecipeChange(uid!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('Erreur: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final recipe = snapshot.data;

        if (recipe == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Aucune recette'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(recipe.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Modifier la recette',
                onPressed: () => context.pushNamed(
                  AppRoute.editRecipe.name,
                  pathParameters: {
                    'uid': recipe.uid,
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async => Share.share(
              recipe.shareDescription,
              subject: recipe.title,
            ),
            tooltip: 'Partager la recette',
            child: const Icon(Icons.share),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (recipe.setupTime != null)
                  Text(
                    'Temps de préparation : ${recipe.setupTime.toTimeString}',
                  ),
                if (recipe.cookingTime != null)
                  Text(
                    'Temps de cuisson : ${recipe.cookingTime.toTimeString}',
                  ),
                if (recipe.standingTime != null)
                  Text(
                    'Temps de repos : ${recipe.standingTime.toTimeString}',
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Ingrédients',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Text(
                      '${recipe.portionCount} portion(s)',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final ingredient in recipe.ingredients)
                  IngredientListTile(ingredient),
                const SizedBox(height: 16),
                Text(
                  'Étapes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                for (final step in recipe.steps)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('- ${step.description}'),
                  ),
                const SizedBox(height: 16),
                if (recipe.sourceUri != null)
                  FilledButton.icon(
                    onPressed: () => launchUrl(recipe.sourceUri!),
                    icon: const Icon(Icons.open_in_new_outlined),
                    label: const Text('Ouvrir la source web'),
                  )
                else
                  Text('Source : ${recipe.source}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

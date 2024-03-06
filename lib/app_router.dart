import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:my_recipes/views/edit_recipe/edit_recipe_view.dart';
import 'package:my_recipes/views/recipe/recipe_view.dart';
import 'package:my_recipes/views/recipes/recipes_view.dart';

export 'package:go_router/go_router.dart';

GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  recipes('/recipes'),
  recipe(':uid'),
  editRecipe('/edit-recipe/:uid'),
  addRecipe('/add-recipe');

  const AppRoute(this.path);

  final String path;
}

final goRouter = GoRouter(
  navigatorKey: _navigatorKey,
  initialLocation: AppRoute.recipes.path,
  debugLogDiagnostics: kDebugMode,
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Lottie.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'lottie/404_dark_mode.json'
            : 'lottie/404_light_mode.json',
      ),
    ),
  ),
  routes: [
    GoRoute(
      path: AppRoute.recipes.path,
      name: AppRoute.recipes.name,
      builder: (context, state) => const RecipesView(),
      routes: [
        GoRoute(
          path: AppRoute.recipe.path,
          name: AppRoute.recipe.name,
          builder: (context, state) {
            final uid = state.pathParameters['uid'];
            return RecipeView(uid: uid);
          },
        ),
      ],
    ),
    GoRoute(
      path: AppRoute.addRecipe.path,
      name: AppRoute.addRecipe.name,
      builder: (context, state) => const EditRecipeView(recipeUid: null),
    ),
    GoRoute(
      path: AppRoute.editRecipe.path,
      name: AppRoute.editRecipe.name,
      builder: (context, state) {
        final recipeUid = state.pathParameters['uid'];
        return EditRecipeView(recipeUid: recipeUid);
      },
    ),
  ],
);

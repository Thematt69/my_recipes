import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:my_recipes/fridge_firebase_options.dart';
import 'package:my_recipes/views/edit_recipe/edit_recipe_view.dart';
import 'package:my_recipes/views/recipe/recipe_view.dart';
import 'package:my_recipes/views/recipes/recipes_view.dart';
import 'package:my_recipes/views/sign_in/sign_in_page.dart';

export 'package:go_router/go_router.dart';

GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  recipes('/recipes'),
  recipe(':uid'),
  editRecipe('/edit-recipe/:uid'),
  addRecipe('/add-recipe'),
  signIn('/sign-in');

  const AppRoute(this.path);

  final String path;
}

final goRouter = GoRouter(
  restorationScopeId: 'fr.thematt69.my_recipes',
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
  redirect: (context, state) {
    final user = FirebaseAuth.instanceFor(
      app: Firebase.app(FridgeFirebaseOptions.name),
    ).currentUser;
    if (user == null) {
      return AppRoute.signIn.path;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoute.signIn.path,
      name: AppRoute.signIn.name,
      builder: (context, state) => const SignInPage(),
    ),
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

import 'package:flutter/material.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/extensions/int_extension.dart';
import 'package:my_recipes/models/recipe.dart';

class RecipeListTile extends StatelessWidget {
  const RecipeListTile(this.recipe, {super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(recipe.title),
      subtitle: recipe.totalTime.toTimeString == null
          ? null
          : Text(recipe.totalTime.toTimeString!),
      trailing: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_forward_ios),
        ],
      ),
      onTap: () {
        context.pushNamed(
          AppRoute.recipe.name,
          pathParameters: {'uid': recipe.uid},
        );
      },
    );
  }
}

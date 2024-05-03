import 'package:flutter/material.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/extensions/int_extension.dart';
import 'package:my_recipes/models/recipe.dart';

class RecipeListTile extends StatelessWidget {
  const RecipeListTile(this.recipe, {super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    Widget? subtitle;

    if (recipe.totalTime.toTimeString != null) {
      subtitle = Text(
        '${recipe.totalTime.toTimeString!} | ${recipe.portionCount} portion(s)',
      );
    } else {
      subtitle = Text('${recipe.portionCount} portion(s)');
    }

    return ListTile(
      title: Text(recipe.title),
      subtitle: subtitle,
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

import 'package:flutter/material.dart';
import 'package:my_recipes/models/recipe_step.dart';

class StepReorderableListView extends StatelessWidget {
  const StepReorderableListView({
    super.key,
    required this.stepsController,
    required this.scrollController,
    required this.isReordering,
  });

  final ValueNotifier<List<RecipeStep>> stepsController;
  final ScrollController scrollController;
  final bool isReordering;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<RecipeStep>>(
      valueListenable: stepsController,
      builder: (context, steps, _) {
        return ReorderableListView.builder(
          scrollController: scrollController,
          buildDefaultDragHandles: false,
          shrinkWrap: true,
          itemCount: steps.length,
          onReorder: (oldIndex, newIndex) {
            final newSteps = List<RecipeStep>.from(steps);
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final step = newSteps.removeAt(oldIndex);
            newSteps.insert(newIndex, step);
            stepsController.value = newSteps;
          },
          itemBuilder: (context, index) {
            final step = steps[index];

            return Padding(
              key: ValueKey(step.uid),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  if (isReordering) ...[
                    ReorderableDragStartListener(
                      key: ValueKey(step.uid),
                      index: index,
                      child: const Icon(Icons.drag_handle),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: TextFormField(
                      initialValue: step.description,
                      onChanged: (value) {
                        final newSteps = List<RecipeStep>.from(
                          steps,
                        );
                        newSteps[index] = RecipeStep(
                          uid: step.uid,
                          description: value,
                        );
                        stepsController.value = newSteps;
                      },
                      decoration: InputDecoration(
                        labelText: 'Étape ${index + 1}*',
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 2,
                      maxLines: null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "L'étape ne peut pas être vide";
                        }
                        return null;
                      },
                      autofocus: index != 0 && step.description.isEmpty,
                    ),
                  ),
                  if (index != 0 && index == steps.length - 1) ...[
                    const SizedBox(width: 12),
                    IconButton.outlined(
                      onPressed: () {
                        final newSteps = List<RecipeStep>.from(steps)
                          ..removeAt(index);
                        stepsController.value = newSteps;
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                  if (step.description.isNotEmpty &&
                      index == steps.length - 1) ...[
                    const SizedBox(width: 12),
                    IconButton.outlined(
                      onPressed: () {
                        final newSteps = List<RecipeStep>.from(steps)
                          ..add(RecipeStep.empty());
                        stepsController.value = newSteps;
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/extensions/int_extension.dart';
import 'package:my_recipes/models/filter_setup.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({
    super.key,
    required this.filterSetup,
  });

  final FilterSetup filterSetup;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late FilterSetup _filterSetup = widget.filterSetup;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrer les recettes'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temps total (en minutes)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          RangeSlider(
            values: RangeValues(
              _filterSetup.minTotalTime.toDouble(),
              _filterSetup.maxTotalTime.toDouble(),
            ),
            labels: RangeLabels(
              _filterSetup.minTotalTime.toTimeString!,
              _filterSetup.maxTotalTime.toTimeString!,
            ),
            divisions: 720 ~/ 15,
            max: 720,
            onChanged: (value) {
              setState(() {
                _filterSetup = _filterSetup.copyWith(
                  minTotalTime: value.start.toInt(),
                  maxTotalTime: value.end.toInt(),
                );
              });
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Sources',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: _filterSetup.webSource,
            onChanged: (value) {
              setState(() {
                _filterSetup = _filterSetup.copyWith(webSource: value);
              });
            },
            title: const Text('Inclure les recettes provenant du web'),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: _filterSetup.bookSource,
            onChanged: (value) {
              setState(() {
                _filterSetup = _filterSetup.copyWith(bookSource: value);
              });
            },
            title: const Text('Inclure les recettes provenant de livre'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(null),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => context.pop(_filterSetup),
          child: const Text('Filtrer'),
        ),
      ],
    );
  }
}

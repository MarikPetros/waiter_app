import 'package:flutter/material.dart';
import '../model/meal.dart';

class InsufficientQuantityDialog extends StatelessWidget {
  final Meal meal;

  const InsufficientQuantityDialog({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(meal.name),
      content: const Text('Недостаточное количество товара на складе'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

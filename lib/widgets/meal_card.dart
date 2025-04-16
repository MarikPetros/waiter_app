import 'dart:io';

import 'package:flutter/material.dart';
import 'package:waiter_app/model/meal.dart';

class MealCard extends StatefulWidget {
  const MealCard({
    super.key,
    required this.cardSize,
    required this.meal,
    required this.onMealTap,
  });

  final double cardSize;
  final Meal meal;
  final Function(Meal) onMealTap;

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onMealTap(widget.meal); // Call the callback function
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          width: widget.cardSize,
          height: widget.cardSize - widget.cardSize / 7,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.grey.shade400,
                width: 1.0, // Set border width
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: widget.cardSize / 2, // Adjust as needed
                          child: Image.file(
                            File(widget.meal.imagePath ?? ''),
                            key: ValueKey(widget.meal.imagePath),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.meal.price.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Склад ${widget.meal.quantity}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Expanded(
                    flex: 0,
                    child: Text(
                      widget.meal.name,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                      key: ValueKey(widget.meal.name),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

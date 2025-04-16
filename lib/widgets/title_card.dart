import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.cardSize,
    required this.label,
  });

  final double cardSize;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardSize,
      height: cardSize - cardSize / 4,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.amber.shade100,
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
    // );
  }
}

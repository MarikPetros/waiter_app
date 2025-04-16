import 'package:flutter/material.dart';

import '../model/meal.dart';
import 'dart:core';

class TileOrderItem extends StatefulWidget {
  const TileOrderItem({
    super.key,
    required this.meal,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onRemoveFromOrder,
    required this.onPriceChange,
  });

  final Meal meal;
  final int quantity;
  final Function(int newQuantity) onQuantityChanged;
  final Function(Meal meal) onRemoveFromOrder;
  final Function(Meal meal, double discount) onPriceChange;

  @override
  State<TileOrderItem> createState() => _TileOrderItemState();
}

class _TileOrderItemState extends State<TileOrderItem> {
  late int _quantity;
  bool _isLongPressed = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    final mealPrice = widget.meal.discountedPrice != null
        ? widget.meal.discountedPrice!
        : widget.meal.price;

    final String mealTotalPrice = (mealPrice * _quantity).toStringAsFixed(1);

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isLongPressed = !_isLongPressed;
        });
      },
      child: AnimatedContainer(
        color: _isLongPressed ? Colors.indigo.shade100 : Colors.transparent,
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.meal.name),
                        _isLongPressed
                            ? Text('$mealPrice x $_quantity = $mealTotalPrice')
                            : Text(mealTotalPrice),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                          widget.onQuantityChanged(_quantity);
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text('$_quantity'),
                      const SizedBox(
                        width: 4,
                      ),
                      IconButton(
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                            widget.onQuantityChanged(_quantity);
                          }
                        },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _isLongPressed
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            widget.onRemoveFromOrder(widget.meal);
                            _isLongPressed = false;
                          });
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.error,
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 16.0)),
                          fixedSize: WidgetStateProperty.all<Size>(
                              const Size(170, 10)),
                        ),
                        child: const Text(
                          'Удалить из счета',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Change price (Implement your logic here)
                          // setState(() {
                          // widget.onPriceChange(widget.meal, );
                          _showDiscountDialog(context);
                          _isLongPressed = false;
                          // });
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context).colorScheme.onPrimaryContainer),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 16.0)),
                          fixedSize: WidgetStateProperty.all<Size>(
                              const Size(170, 10)),
                        ),
                        child: const Text(
                          'Изменить цену',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }

  void _showDiscountDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          double discount = widget.meal.discountedPrice ??
              0; // Initialize with current discount or 0
          return AlertDialog(
            title: const Text('Изменить цену'),
            content: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Скидка'),
                    Slider(
                      value: discount,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: '${discount.toInt()}%',
                      onChanged: (value) {
                        setState(() {
                          discount = value;
                        });
                      },
                      onChangeEnd: (value) {
                        setState(() {
                          discount = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Calculate the discounted price
                        final double discountedPrice =
                            (widget.meal.price * (1 - (discount / 100)));
                        // Update the meal's discounted price
                        widget.onPriceChange(
                          widget.meal,
                          discountedPrice,
                        );
                        // Update the state of the widget
                        setState(() {
                          widget.meal.discountedPrice =
                              discountedPrice; // Update the meal's discounted price
                        });
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}

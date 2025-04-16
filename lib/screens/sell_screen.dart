import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiter_app/providers/meals_provider.dart';
import 'package:waiter_app/widgets/commmon_scaffold.dart';
import 'package:waiter_app/widgets/custom_app_bar.dart';
import 'package:waiter_app/widgets/meal_card.dart';
import 'package:waiter_app/widgets/tile_order_item.dart';
import 'package:waiter_app/widgets/title_card.dart';

import '../model/meal.dart';
import '../providers/orders_provider.dart';
import '../widgets/insufficient_quantity_dialog.dart';

class SellScreen extends ConsumerStatefulWidget {
  const SellScreen({super.key, this.orderNumber = 1});

  final int orderNumber;

  @override
  ConsumerState<SellScreen> createState() {
    return _SellScreenState();
  }
}

class _SellScreenState extends ConsumerState<SellScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(mealsProvider.notifier).loadMeals();
  }

  Map<Meal, int> orderedMeals = {};

  void handleMealTap(Meal meal) {
    setState(() {
      if (!orderedMeals.containsKey(meal)) {
        orderedMeals[meal] = 1;
      } else {
        orderedMeals[meal] = orderedMeals[meal]! + 1;
      }
    });
  }

  void onRemoveFromOrder(Meal meal) {
    setState(() {
      orderedMeals.remove(meal);
    });
  }

  void onPriceChange(Meal meal, double discount) {
    setState(() {});
  }

  Future<void> _updateOrderAndMeals() async {
    if(orderedMeals.isEmpty) {
      try {
        await ref
            .read(ordersProvider.notifier).deleteOrder(widget.orderNumber);
      } catch (error) {
        // Handle errors here (e.g., log the error, show a message)
        print('Error removing order: $error');
      }
    }
    else {
      final newOrderedMeals = convertOrderedMeals(orderedMeals);
      try {
        await ref
            .read(ordersProvider.notifier)
            .updateOrder(widget.orderNumber, newOrderedMeals);
        await updateMealsDBQuantities(orderedMeals);
      } catch (error) {
        // Handle errors here (e.g., log the error, show a message)
        print('Error updating order: $error');
      }
    }
  }

  bool isMealAvailable = true;

  Future<void> updateMealsDBQuantities(Map<Meal, int> orderedMeals) async {
    for (var entry in orderedMeals.entries) {
      final meal = entry.key;
      final soldQuantity = entry.value;
      try {
        if (soldQuantity > meal.quantity) {
          setState(() {
            isMealAvailable = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return InsufficientQuantityDialog(meal: meal);
            },
          );
          return;
        }
        await ref
            .read(mealsProvider.notifier)
            .updateQuantity(meal.id, meal.quantity - soldQuantity);
      } catch (error) {
        // Handle errors here (e.g., log the error, show a message)
        print('Error updating meal quantity: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);

    double cardSize = MediaQuery.of(context).size.width / 2 - 26;
    double mealsPartSize = MediaQuery.of(context).size.height / 2;

    final meals = ref.watch(mealsProvider);
    final beverages =
        meals.where((meal) => meal.category == 'beverage').toList();
    final foods = meals.where((meal) => meal.category == 'food').toList();

    final mealController = TextEditingController();

    return DefaultTabController(
      length: 2,
      child: CommonScaffold(
        appBar: CustomAppBar(
          title: 'Режим продаж',
          onSearchPress: () {},
          showDrawerIcon: true,
        ),
        body: Column(
          children: [
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: 'Товары(${meals.length})'),
                const Tab(text: 'Параметры'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        SizedBox(
                          height: mealsPartSize * 1.8 / 3,
                          child: orderedMeals.isEmpty
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ListView.builder(
                                    itemCount: orderedMeals.length,
                                    itemBuilder: (context, index) {
                                      final meal =
                                      orderedMeals.keys.elementAt(index);
                                      var quantity = orderedMeals[meal]!;
                                      return TileOrderItem(
                                        key: ValueKey(meal.id),
                                        meal: meal,
                                        quantity: quantity,
                                        onQuantityChanged: (quantity) {
                                          setState(() {
                                            orderedMeals[meal] = quantity;
                                          });
                                        },
                                        onRemoveFromOrder: (meal) {
                                          setState(() {
                                            onRemoveFromOrder(meal);
                                          });
                                        },
                                        onPriceChange: (meal, double) {
                                          onPriceChange(meal, double);
                                        },
                                      );
                                    },
                                  ),
                                ),
                        ),
                        Flexible(
                          flex: 2,
                          // child: SizedBox(
                          //   height: mealsPartSize - 36,
                            // child: Flexible(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Column(
                                      children: [
                                        TitleCard(
                                            cardSize: cardSize,
                                            label: 'Напитки'),
                                        Flexible(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: beverages.length,
                                            itemBuilder: (ctx, index) =>
                                                MealCard(
                                              cardSize: cardSize,
                                              meal: beverages[index],
                                              onMealTap: handleMealTap,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        TitleCard(
                                            cardSize: cardSize, label: 'Блюда'),
                                        Flexible(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: foods.length,
                                            itemBuilder: (ctx, index) =>
                                                MealCard(
                                              cardSize: cardSize,
                                              meal: foods[index],
                                              onMealTap: handleMealTap,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            // ),
                          // ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: mealController,
                            decoration: InputDecoration(
                              hintText: 'Поиск',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: Colors.black45),
                              suffixIcon: GestureDetector(
                                onTap: () async {
                                  await _updateOrderAndMeals();
                                  // Add logic for QR code generation here if needed
                                },
                                child: Icon(
                                  Icons.qr_code_scanner,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Center(
                    child: Text('Параметры'),
                  ),
                ],
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }
}

class ModifiedMeal {
  final String name;
  final double originalPrice;
  double modifiedPrice;

  ModifiedMeal({
    required this.name,
    required this.originalPrice,
    required this.modifiedPrice,
  });
}
